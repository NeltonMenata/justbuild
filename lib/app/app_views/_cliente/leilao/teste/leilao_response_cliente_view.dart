import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:pinonline/app/app_controller/_cliente/cliente_login_controller.dart';
import 'package:pinonline/app/app_models/cliente_model.dart';

import 'leilao_cliente_view.dart';

class LeilaoResponseClienteView extends StatelessWidget {
  ClienteModel get cliente => ClienteLoginController.controller.cliente[0];
  ControllerLeilao get _controller => ControllerLeilao.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leilões Respondidos")),
      body: Center(
        child: Column(
          children: [
            Text("Leilões Pedidos",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Expanded(
                child: FutureBuilder<List<ParseObject>>(
                    future: _controller.clienteLeilao(cliente.objectId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: (){
                                      if(snapshot.data![index]["clienteDone"] == true){
                                          Get.snackbar("Cliente", "Cliente aceitou o valor de leilão");
                                      }
                                    },
                                    tileColor: snapshot.data![index]["clienteDone"] == true ? Colors.orange.withOpacity(0.4): Colors.transparent,
                                    title: Text(
                                        "Título: ${snapshot.data![index]["titulo"]}"),
                                    subtitle: Text(
                                        "Valor da Proposta: ${snapshot.data![index]["valorProposta"]}"),
                                    trailing: snapshot.data![index]
                                                ["clienteDone"] ==
                                            true
                                        ? Chip(
                                            label: Text("Aceitado"),
                                            avatar: Icon(Icons.check),
                                            backgroundColor: Colors.green,
                                          )
                                        : ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Aceitar")),
                                  ),
                                  Text(
                                      "Descrição da obra: ${snapshot.data![index]["descricao"]}"),
                                  Text(
                                      "Valor limite do Leilão: ${snapshot.data![index]["valorMax"]}"),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: snapshot.data!.length);
                      } else if (snapshot.hasError) {
                        return Text("Erro: ${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    }))
          ],
        ),
      ),
    );
  }
}
