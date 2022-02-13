import 'dart:html';

import 'package:cryptocoins_app/configs/app_settings.dart';
import 'package:cryptocoins_app/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfigsPage extends StatefulWidget {
  const ConfigsPage({Key? key}) : super(key: key);

  @override
  _ConfigsPageState createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();

    final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações de conta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text('Saldo'),
              subtitle: Text(real.format(account.bank_balance),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.indigo[600],
                  )),
              trailing: IconButton(
                  onPressed: updateBankBalance,
                  icon: Icon(Icons.edit_outlined)),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  updateBankBalance() async {
    final formKey = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.bank_balance.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Saldo'),
      content: Form(
          key: formKey,
          child: TextFormField(
            controller: value,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe o valor do saldo !';
              } else {
                return null;
              }
            },
          )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              account.setBankBalance(double.parse(value.text));
              Navigator.pop(context);
            }
          },
          child: Text('Salvar'),
        )
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }
}
