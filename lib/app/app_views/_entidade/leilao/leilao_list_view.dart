import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinonline/app/app_views/_entidade/leilao/leilao_admin_controller.dart';
import 'package:pinonline/app/app_views/_entidade/leilao/leilao_response_entidade_view.dart';

class LeilaoListView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Leilão - Profissionais"),
      ),
      body: GetBuilder<LeilaoAdminController>(
        init: LeilaoAdminController(),
        builder: (_) => Container(
          width: double.infinity,
          child: _controller.isDoneListaLeilao == true
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text("${_controller.listaLeilao[index]["titulo"]}"),
                      subtitle: Text(
                          "${_controller.listaLeilao[index]["descricao"]}"),
                      onTap: () {
                        Get.to(LeilaoResponseEntidadeView(),
                            arguments: _controller.listaLeilao[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: _controller.listaLeilao.length,
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
