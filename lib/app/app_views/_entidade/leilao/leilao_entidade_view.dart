import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'leilao_admin_controller.dart';
import 'package:pinonline/app/app_views/_size/size.dart';

import 'leilao_entidade_select_view.dart';

class LeilaoEntidadeView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leilões Disponíveis")),
      body: Center(
        child: ListView(
          children: [
            GetBuilder(
              init: LeilaoAdminController(),
              builder: (_) => SizedBox(
                height: alturaPor(90, context),
                child: _controller.isDonePropostaLeilao == true
                    ? _controller.entidadeListaPropostaLeilao.length > 0
                        ? ListView.separated(
                            separatorBuilder: (context, index) => Divider(),
                            itemCount:
                                _controller.entidadeListaPropostaLeilao.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Cliente: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(_controller
                                            .entidadeListaPropostaLeilao[index]
                                                ["leilao"]["cliente"]["nome"]
                                            .toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Descrição da Obra: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${_controller.entidadeListaPropostaLeilao[index]["leilao"]["descricao"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Valor de Leilão: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(_controller
                                            .entidadeListaPropostaLeilao[index]
                                                ["leilao"]["valorMax"]
                                            .toString()),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextButton.icon(
                                      icon: Icon(Icons.send_rounded),
                                      onPressed: () {
                                        Get.to(LeilaoEntidadeSelect(),
                                            arguments: _controller
                                                    .entidadeListaPropostaLeilao[
                                                index]);
                                      },
                                      label: Text("Ver mais!"),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: Text("Nenhum Leilão Encontrado!!",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          )
                    : Center(child: CircularProgressIndicator()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
