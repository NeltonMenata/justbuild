import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
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
      body: Container(
        width: double.infinity,
        child: FutureBuilder<List<ParseObject>>(
          future: _controller.listaLeilao(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${snapshot.data![index]["titulo"]}"),
                  subtitle: Text("${snapshot.data![index]["descricao"]}"),
                  onTap: () {
                    Get.to(LeilaoResponseEntidadeView(),
                        arguments: snapshot.data![index]);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: snapshot.data!.length,
            );
            }else if(snapshot.hasError){
              return Text("Erro: ${snapshot.error}");
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
            //////////
          },
        ),
      ),
    );
  }
}
