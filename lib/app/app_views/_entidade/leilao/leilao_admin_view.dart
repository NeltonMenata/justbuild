import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'leilao_admin_controller.dart';
import 'leilao_admin_select_view.dart';

class LeilaoAdminView extends StatelessWidget {
  const LeilaoAdminView({Key? key}) : super(key: key);
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(actions: [], title: Text("Leilões Solictados por Cliente")),
      body: GetBuilder<LeilaoAdminController>(
        init: LeilaoAdminController(),
        builder: (_) => Center(
          child: _controller.isDoneListaLeilao == true
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _controller.listaLeilao[index]["cliente"]
                                        ["nome"]
                                    .toString(),
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Text(
                              "Título: ${_controller.listaLeilao[index]["titulo"]}"),
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
                                  Get.to(LeilaoAdminSelectView(),
                                      arguments:
                                          _controller.listaLeilao[index]);
                                },
                                icon: Icon(Icons.send_rounded),
                                label: Text("Ver mais:")),
                            onTap: () async {},
                          ),
                          Text(
                              "Localização da Obra: ${_controller.listaLeilao[index]["localizacao"]}"),
                        ],
                      ),
                    );
                  },
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
