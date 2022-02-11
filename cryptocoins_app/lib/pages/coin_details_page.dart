import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cryptocoins_app/models/coin.dart';

class CoinDetailsPage extends StatefulWidget {
  Coin coin;
  CoinDetailsPage({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinDetailsPageState createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  // * Number format to BRL coin
  NumberFormat real = NumberFormat.currency(
    locale: 'pt-BR',
    name: 'R\$',
  );

  // * Values to controll the form
  final _formKey = GlobalKey<FormState>();
  final _valueCoin = TextEditingController();

  // * Responsive coin conversor
  late double qtyCoin = 0;

  // * Purchase function
  buyCoin() {
    if (_formKey.currentState!.validate()) {
      // ! Implement save purchase method

      Navigator.pop(context);
      // * Purchase feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Compra realizada com sucesso!'),
          backgroundColor: Colors.lightGreen,
        ),
      );
    } else {
      // * Purchase feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível realizar a compra!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.coinName),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 10,
            right: 8,
          ),
          child: Row(children: [
            // * Coin Image
            SizedBox(
              child: Image.asset(widget.coin.icon),
              width: 50,
            ),
            SizedBox(width: 8),
            // * Coin Details
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.coin.coinName + ' - ' + widget.coin.initials,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    real.format(widget.coin.cost),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ]),
          ]),
        ),
        // * Responsive coin conversor
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                (qtyCoin > 0)
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: Text('$qtyCoin ${widget.coin.initials}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.teal[400],
                              )),
                          margin: EdgeInsets.only(bottom: 16),
                          alignment: Alignment.center,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 24),
                      ),
                // * Purchase field
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _valueCoin,
                    // * Input Style
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Digite o valor que deseja comprar',
                      labelText: 'Valor',
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      suffix: Text(
                        'R\$(reais)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    // * Input Validation
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o valor da compra';
                      } else if (double.parse(value) < 50) {
                        return 'Valor mínimo para compra de R\$ 50,00';
                      } else {
                        return null;
                      }
                    },
                    // * Dynamic interaction with the coin conversor
                    onChanged: (value) {
                      setState(() {
                        qtyCoin = (value.isEmpty)
                            ? 0
                            : double.parse(value) / widget.coin.cost;
                      });
                    },
                  ),
                ),
                // * Purchase button
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: buyCoin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Comprar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
