import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'leilao_admin_controller.dart';

class LeilaoEntidadeSelect extends StatelessWidget {
  const LeilaoEntidadeSelect({Key? key}) : super(key: key);
  LeilaoAdminController get _controller => LeilaoAdminController.controller;
  @override
  Widget build(BuildContext context) {
    var propostaLeilao = Get.arguments as ParseObject;
    var textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Proposta"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              ListTile(
                title: Text("Descrição da Obra:"),
                subtitle:
                    Text("${propostaLeilao.get("leilao").get("descricao")}"),
              ),
              ListTile(
                title: Text("Localização da Obra:"),
                subtitle:
                    Text("${propostaLeilao.get("leilao").get("localizacao")}"),
              ),
              ListTile(
                title: Text("Valor do Leilão da Obra:"),
                subtitle:
                    Text("${propostaLeilao.get("leilao").get("valorMax")}"),
              ),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Digite o valor de proposta do leilão",
                    border: OutlineInputBorder()),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   
                    _controller.respostaEntidadeLeilao(
                        double.parse(textController.text),
                        propostaLeilao["objectId"],
                        context,
                        objectIdLeilao: propostaLeilao["leilao"]["objectId"]);
                  },
                  child: Text("Enviar"),
                ),
              ),
              Expanded(
                  child: GetBuilder<LeilaoAdminController>(
                    init: LeilaoAdminController(),
                    builder:(_)=> Center(
                        child: _controller.isSend == true
                            ? CircularProgressIndicator()
                            : Container()),
                  ))
            ],
          )),
    );
  }
}
