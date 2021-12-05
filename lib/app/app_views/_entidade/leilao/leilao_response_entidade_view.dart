import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:pinonline/app/app_controller/_entidade/entidade_login_controller.dart';
import 'package:pinonline/app/app_models/entidade_model.dart';
import 'package:pinonline/app/app_views/_size/size.dart';
import 'leilao_admin_controller.dart';

class LeilaoResponseEntidadeView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  EntidadeModel get entidade => EntidadeLoginController.controller.entidade[0];
  @override
  Widget build(BuildContext context) {
    var objectIdLeilao = Get.arguments["objectId"];
    var leilaoTitulo = Get.arguments["titulo"].toString();
    var leilaoDesc = Get.arguments["descricao"].toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text("Respostas dos Profissionais"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: _controller.adminLeilaoResponseEntidade(objectIdLeilao),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.length > 0
                      ? ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Profissional: ${snapshot.data![index]["entidade"]["nome"]}"),
                                        ]),
                                    subtitle: Text(
                                        "Valor Proposta: ${snapshot.data![index]["valorProposta"]}"),
                                    onTap: () {},
                                    trailing: snapshot.data![index]
                                                ["winLeilao"] ==
                                            true
                                        ? Chip(
                                            label: Text("Vencedor do Leilão"),
                                            avatar: Icon(Icons.check),
                                            elevation: 4,
                                            backgroundColor: Colors.green[500],
                                          )
                                        : Chip(
                                            label: Text(
                                                "Concorrendo para o Leilão"),
                                            avatar: Icon(
                                                Icons.change_circle_outlined),
                                            elevation: 4,
                                            backgroundColor: Colors.orange[500],
                                          ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        "Cliente: ${snapshot.data![index]["leilao"]["cliente"]["nome"].toString()}"),
                                    subtitle: Text(
                                        "Valor limite do Leilão: ${snapshot.data![index]["leilao"]["valorMax"].toString()}"),
                                  ),
                                  ListTile(
                                    title: Text("Descrição: "),
                                    subtitle: Text(
                                        "Valor posto em Leilão: ${snapshot.data![index]["leilao"]["descricao"]}"),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data!.length)
                      : Center(
                          child: SizedBox(
                            width: larguraPor(70, context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  title: Text("$leilaoTitulo"),
                                  subtitle: Text("$leilaoDesc"),
                                ),
                                Text(
                                    "Este Leilão ainda não foi respondido por algum Profissional!")
                              ],
                            ),
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Text("Erro: " + snapshot.error.toString());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
