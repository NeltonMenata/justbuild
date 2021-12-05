import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'leilao_admin_controller.dart';
import 'package:pinonline/app/app_views/_size/size.dart';

// ignore: must_be_immutable
class LeilaoAdminSelectView extends StatelessWidget {
  LeilaoAdminController get _controller => LeilaoAdminController.controller;

  @override
  Widget build(BuildContext context) {
    var leilao = Get.arguments as ParseObject;
    return WillPopScope(
      onWillPop: () async {
        _controller.entidade!.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dados do Cliente"),
          actions: [
            Container(
              child: leilao["clienteDone"] == true
                                  ? TextButton(
                  onPressed: () {
                    _controller.sendProgressIndicator(true);
                    _controller.enviaPropostaLeilao(
                        leilao.objectId!, leilao["cliente"]["objectId"]);
                  },
                  child: Text("Criar\nLeilão")):TextButton(
                  onPressed: () {
                    },
                  child: Text("Leilão\nIndisponível", style: TextStyle(color: Colors.black))),
            )
          ],
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
              child: GetBuilder<LeilaoAdminController>(
                init: LeilaoAdminController(),
                builder: (_) => SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: alturaPor(70, context),
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text("Nome:"),
                              subtitle: Text(
                                leilao.get("cliente").get("nome"),
                              ),
                              trailing: leilao["clienteDone"] == true
                                  ? Chip(
                                      label: Text("Cliente Aceitou"),
                                      avatar: Icon(Icons.check),
                                      backgroundColor: Colors.green,
                                    )
                                  : Chip(
                                      label: Text("Aguarde confirmação"),
                                      avatar:
                                          Icon(Icons.change_circle_outlined),
                                      backgroundColor: Colors.blue,
                                    ),
                            ),
                            ListTile(
                              title: Text("Email:"),
                              subtitle: Text(
                                leilao["cliente"]["email"].toString(),
                              ),
                            ),
                            ListTile(
                              title: Text("Telefone:"),
                              subtitle: Text(
                                leilao["cliente"]["telefone"].toString(),
                              ),
                            ),
                            ListTile(
                              title: Text("Descrição do Leilão:"),
                              subtitle: Text(
                                leilao.get("descricao").toString(),
                              ),
                            ),
                            ListTile(
                              title: Text("Valor Limite do Leilão:"),
                              subtitle: leilao["clienteDone"] == true
                                  ? Text("${leilao["valorMax"]}")
                                  : Column(
                                    children: [
                                      TextField(
                                        controller: _controller.valorLimite,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                        ElevatedButton(onPressed: (){
                                          _controller.sendValorLimite(context, leilao["objectId"]);
                                        }, child: Text("Enviar valor limite para Cliente"))
                                    ],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("Baixar PDF")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GetBuilder<LeilaoAdminController>(
              init: LeilaoAdminController(),
              builder: (_) => Container(
                height: 50,
                child: Center(
                    child: _controller.isSend
                        ? CircularProgressIndicator()
                        : Container()),
              ),
            )
          ],
        )),
      ),
    );
  }
}
