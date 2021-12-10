import 'package:flutter/material.dart';
import 'package:form_validation_assignment/form_data.dart';
import 'package:form_validation_assignment/state_repository.dart';

const _title = 'Form Validation Assignment';
const _minInterests = 3;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: FormPage(minInterests: _minInterests),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({
    required this.minInterests,
    Key? key,
  }) : super(key: key);

  final int minInterests;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = FormData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SuccessPage(_formData)));
            }
          },
          label: const Text('Submit'),
          icon: const Icon(Icons.save),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (v) => _formData.name = v,
                  validator: (v) {
                    if (v?.isEmpty ?? true) {
                      return 'Name must not be empty.';
                    }
                    if (v!.split(' ').length < 2) {
                      return 'You must enter your full-name';
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (v) => _formData.interests = v.split(',').map((e) => e.trim()).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Interests',
                    hintText: 'Separate your interests with a comma.',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty || v.split(',').length < widget.minInterests) {
                      return 'You must have at least ${widget.minInterests} interests.';
                    }
                  },
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<String>>(
                  future: StateRepository().getStates(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Text('Unauthenticated.');
                    }

                    if (!snap.hasData) {
                      return const CircularProgressIndicator();
                    }

                    return DropdownButtonFormField<String>(
                      validator: (v) => v == null ? 'A state must be selected.' : null,
                      hint: const Text('Select a state'),
                      value: _formData.selectedState,
                      items: snap.data!
                          .map(Text.new)
                          .map(
                            (text) => DropdownMenuItem(
                              child: text,
                              value: text.data,
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _formData.selectedState = v),
                    );
                  },
                ),
              ]
                  .map((e) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: e,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage(this.formData, {Key? key}) : super(key: key);

  final FormData formData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You successfully submitted the form!',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const FormPage(minInterests: _minInterests)),
                );
              },
              child: const Text('Create another'),
            ),
            const SizedBox(height: 30),
            Text(
              'Form data:',
              style: Theme.of(context).textTheme.headline6,
            ),
            ...[
              'Name: ${formData.name!}',
              'Interests: ${formData.interests!.join(', ')}',
              'State: ${formData.selectedState!}',
            ]
                .map(Text.new)
                .map((text) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: text,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
