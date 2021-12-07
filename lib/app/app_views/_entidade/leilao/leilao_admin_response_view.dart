import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinonline/app/app_views/_entidade/leilao/leilao_response_entidade_view.dart';

import 'leilao_admin_controller.dart';

class LeilaoAdminResponseView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(actions: [], title: Text("Leilões Solicitados por Cliente")),
      body: GetBuilder<LeilaoAdminController>(
        init: LeilaoAdminController(),
        builder: (_) => Center(
          child: _controller.isDoneListaLeilao == true
              ? _controller.listaLeilao.length > 0
                  ? ListView.builder(
                      itemCount: _controller.listaLeilao.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Cliente: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _controller.listaLeilao[index]["cliente"]
                                            ["nome"]
                                        .toString(),
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              ListTile(
                                title: Text(
                                  "Descrição: " +
                                      _controller.listaLeilao[index]
                                          .get("descricao"),
                                ),
                                subtitle: Text(
                                  "Valor de Leilão: " +
                                      _controller.listaLeilao[index]
                                          .get("valorMax")
                                          .toString(),
                                ),
                                trailing: TextButton.icon(
                                    onPressed: () {
                                      Get.to(LeilaoResponseEntidadeView(),
                                          arguments: _controller
                                              .listaLeilao[index]["objectId"]
                                              .toString());
                                    },
                                    icon: Icon(Icons.send_rounded),
                                    label: Text("Ver respostas")),
                                onTap: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Text("Nenhum Leilão Solicitado",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
