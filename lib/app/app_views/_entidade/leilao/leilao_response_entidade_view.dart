import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinonline/app/app_controller/_entidade/entidade_login_controller.dart';
import 'package:pinonline/app/app_models/entidade_model.dart';
import 'leilao_admin_controller.dart';

class LeilaoResponseEntidadeView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  EntidadeModel get entidade => EntidadeLoginController.controller.entidade[0];
  @override
  Widget build(BuildContext context) {
    var leilaoTitulo = Get.arguments["titulo"].toString();
    var leilaoDesc = Get.arguments["descricao"].toString();
    var leilaoObjectId = Get.arguments["objectId"].toString();
    _controller.adminLeilaoResponseEntidade.forEach((element) {
      print("################### " +
          leilaoObjectId +
          "  ##########################");
      print("########## " + element["leilao"].objectId! + " ###########");
      if (element["leilao"]["objectId"] == leilaoObjectId) {
        _controller.newALRE.add(element);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text("Respostas dos Profissionais"),
      ),
      body: Column(
        children: [
          GetBuilder<LeilaoAdminController>(
            init: LeilaoAdminController(),
            builder: (_) => Expanded(
              child: _controller.isDoneALREF == true
                  ? _controller.newALRE.length > 0
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
                                              "Profissional: ${_controller.newALRE[index]["entidade"]["nome"]}"),
                                        ]),
                                    subtitle: Text(
                                        "Valor Proposta: ${_controller.newALRE[index]["valorProposta"]}"),
                                    onTap: () {},
                                    trailing: _controller.newALRE[index]
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
                                        "Cliente: ${_controller.newALRE[index]["leilao"]["cliente"]["nome"].toString()}"),
                                    subtitle: Text(
                                        "Valor limite do Leilão: ${_controller.newALRE[index]["leilao"]["valorMax"].toString()}"),
                                  ),
                                  ListTile(
                                    title: Text("Descrição: "),
                                    subtitle: Text(
                                        "Valor posto em Leilão: ${_controller.newALRE[index]["leilao"]["descricao"]}"),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: _controller.newALRE.length)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text(leilaoTitulo),
                              subtitle: Text(leilaoDesc),
                            ),
                            Text(
                              "Nenhum resposta dos Profissionais foi encontrado para esse Leilão",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
