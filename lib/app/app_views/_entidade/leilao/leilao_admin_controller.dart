import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinonline/app/app_controller/_entidade/entidade_login_controller.dart';
import 'package:pinonline/app/app_models/entidade_model.dart';
import 'package:pinonline/app/app_models/leilao_cliente_model.dart';

class LeilaoAdminController extends GetxController {
  static final controller = Get.put(LeilaoAdminController());

  LeilaoClienteModel? leilao;
  final List<EntidadeModel>? entidade = [];
  var valorProposta = TextEditingController();
  var valorLimite = TextEditingController();

  EntidadeModel get _entidade => EntidadeLoginController.controller.entidade[0];

  //
  var isDonePropostaLeilao = false;
  // Variavel que seleciona todos
  bool isSelected = false;

  // Variavel que verifica se está enviando proposta
  var isSend = false;

  toggleSelectEntidade(bool value, int index) {
    entidade![index].isSelected = value;
    update();
  }

  void sendProgressIndicator(bool value) {
    this.isSend = value;
    update();
  }

  Future<void> sendValorLimite(
      BuildContext context, String objectIdLeilao) async {
    if (this.valorLimite.text.isEmpty) {
      Get.snackbar("Erro", "Digite o valor limite do leilão",
          backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    final leilao = ParseObject("Leilao")
      ..objectId = objectIdLeilao
      ..set("valorMax", double.parse(this.valorLimite.text));
    await leilao.save();
    this.valorLimite.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Leilão"),
            content: Text(
                "Envio do valor limite do leilão para o cliente foi feito com sucesso"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void toggleSelectionAll() {
    isSelected = !isSelected;
    for (int c = 0; c < entidade!.length; c++) {
      entidade![c].isSelected = isSelected;
    }
    update();
  }

// Função que envia uma Proposta Leilao no Back4app na class PropostaLeilao
//
  Future<void> enviaPropostaLeilao(
      String objectIdLeilao, String objectIdCliente) async {
    try {
      final entidades = QueryBuilder(ParseObject("Entidade"))
        ..whereEqualTo("leilaoPago", true);
      final response = await entidades.query();
      response.results!.forEach((element) {
        entidade!.add(EntidadeModel(
            nome: element["nome"],
            senha: element["senha"],
            categoria: element["categoria"].toString(),
            contacto: element["contacto"].toString(),
            email: element["email"],
            morada: element["morada"].toString(),
            desc: element["descricao"].toString(),
            img: element["img"]["url"],
            objectId: element["objectId"],
            admin: element["admin"],
            isSelected: element["isSelected"]));
      });

      entidade!.forEach((element) {
        print(objectIdCliente);
        _funtionEntidade(element, objectIdLeilao, objectIdCliente);
      });
      this.sendProgressIndicator(false);
    } catch (e) {
      Get.snackbar("Erro", "Mensagem: $e");
    }
  }

  // Função que retorna Lista de todos os pedidos de Leilão
  Future<List<ParseObject>> listaLeilao() async {
    try {
      final queryLeilao = QueryBuilder(ParseObject("Leilao"))
        ..orderByDescending("createdAt")
        ..includeObject(["cliente"]);
      final response = await queryLeilao.query();
      if (response.results != null && response.success) {
        return response.results as List<ParseObject>;
      }
      return [];
    } catch (e) {
      Get.snackbar("Erro", "Erro ao consultar os Leilões no sistema: $e");
      return [];
    }
  }

  // Função que retorna todos os Profissionais que pagam para estar no Leilão
  Future<List<ParseObject>> entidadeLeilao() async {
    try {
      final queryEntidadeLeilao = QueryBuilder(ParseObject("Entidade"));
      queryEntidadeLeilao
        ..whereEqualTo("leilaoPago", true)
        ..orderByAscending("nome");

      // ..whereEqualTo("categoria", "value");
      final response = await queryEntidadeLeilao.query();
      if (response.success && response.results != null) {
        return response.results as List<ParseObject>;
      }
      return [];
    } catch (e) {
      Get.snackbar("Erro", "Erro ao carregar as Entidades: $e");
      return [];
    }
  }

  Future<void> _funtionEntidade(EntidadeModel element, String objectIdLeilao,
      String objectIdCliente) async {
    final query = QueryBuilder(ParseObject("PropostaLeilao"))
      ..whereEqualTo("entidade",
          (ParseObject("Entidade")..objectId = element.objectId).toPointer())
      ..whereEqualTo("leilao",
          (ParseObject("Leilao")..objectId = objectIdLeilao).toPointer());
    final response = await query.query();

    if (response.results != null) {
      Get.snackbar("Proposta Leilão",
          "O usuário ${element.nome} já recebeu essa proposta de leilão",
          backgroundColor: Colors.orange.withOpacity(0.5));
      return;
    }

    final propostaLeilao = ParseObject("PropostaLeilao")
      ..set("entidade", ParseObject("Entidade")..objectId = element.objectId)
      ..set("cliente", ParseObject("Cliente")..objectId = objectIdCliente)
      ..set("leilao", ParseObject("Leilao")..objectId = objectIdLeilao)
      ..set("propostaAceite", false);

    await propostaLeilao.save();
    Get.snackbar(
        "Proposta de Leilão", "A proposta leilão foi enviada com sucesso");
  }

  // Função que set com o valor true a variavel propostaAceite no back4app na class PropostaLeilao
  // Habilitando assim este Profissional para fornecer o serviço ou vencidor do leilão
  Future<void> aceitaPropostaLeilao(
      String objectIdProposta, String objectIdLeilao) async {
    try {
      final qLeilaoIsDone = QueryBuilder(ParseObject("PropostaLeilao"))
        ..whereEqualTo(
            "leilao", ParseObject("Leilao")..objectId = objectIdLeilao)
        ..whereEqualTo("propostaAceite", true);
      final response = await qLeilaoIsDone.query();
      if (response.results != null && response.success) {
        Get.snackbar("Proposta de Leilao",
            "Este Leilão já foi atribuído a outro Profissional",
            backgroundColor: Colors.red.withOpacity(0.5));
        return;
      }

      final aceitaProposta = ParseObject("PropostaLeilao")
        ..set("propostaAceite", true)
        ..objectId = objectIdProposta;
      await aceitaProposta.save();
      Get.snackbar("Proposta Leilão",
          "Proposta foi atribuida ao Profissional com sucesso",
          backgroundColor: Colors.green.withOpacity(0.5));
    } catch (e) {
      Get.snackbar("Erro", "Mensagem: $e");
    }
  }

  // Função que retorna todas as Propostas de Leilão da class PropostaLeilao
  Future<List<ParseObject>> propostaLeilao() async {
    try {
      final response =
          await QueryBuilder(ParseObject("PropostaLeilao")).query();
      if (response.success && response.results != null) {
        return response.results as List<ParseObject>;
      }
      return [];
    } catch (e) {
      Get.snackbar("Erro", "Mensagem: $e");
      return [];
    }
  }

  // Função que retorna uma lista de Proposta de Leilão
  // recebe o objectId da Entidade e retorna todas Propostas de Leilão
  // onde é igual ao objectId da Entidade
  List<ParseObject> entidadeListaPropostaLeilao = [];
  Future<List<ParseObject>> _entidadeListaPropostaLeilao(
      String objectIdEntidade) async {
    try {
      final query = QueryBuilder(ParseObject("PropostaLeilao"))
        ..includeObject(["leilao", "leilao.cliente"])
        ..whereEqualTo(
            "entidade", ParseObject("Entidade")..objectId = objectIdEntidade);
      final response = await query.query();
      if (response.results != null && response.success) {
        return response.results! as List<ParseObject>;
      }
      return [];
    } catch (e) {
      Get.snackbar("Erro", "Mensagem: $e");
      return [];
    }
  }

  LiveQuery liveQueryPropostaLeilao = LiveQuery();
  late Subscription subPropostaLeilao;
  // Inicializa entidadeListaPropostaLeilao()
  Future<void> startPropostaLeilao() async {
    var objectIdEntidade = _entidade.objectId;
    entidadeListaPropostaLeilao =
        await _entidadeListaPropostaLeilao(objectIdEntidade);

    isDonePropostaLeilao = true;
    update();
    final queryProposta = QueryBuilder(ParseObject("PropostaLeilao"))
      ..whereEqualTo(
          "entidade", ParseObject("Entidade")..objectId = objectIdEntidade)
      ..includeObject(["leilao", "leilao.cliente"]);
    subPropostaLeilao =
        await liveQueryPropostaLeilao.client.subscribe(queryProposta);
    subPropostaLeilao.on(LiveQueryEvent.update, (ParseObject value) {
      print(value);
      _livePropostaLeilao(objectIdEntidade, value.objectId!);
    });
  }

  Future<void> _livePropostaLeilao(
      String objectIdEntidade, String objectIdPro) async {
    final queryProposta = QueryBuilder(ParseObject("PropostaLeilao"))
      ..whereEqualTo(
          "entidade", ParseObject("Entidade")..objectId = objectIdEntidade)
      ..includeObject(["leilao", "leilao.cliente"]);
    var result = await queryProposta.first();
    if (result == null) return;
    entidadeListaPropostaLeilao.add(result);
    update();
  }

  Future<void> respostaEntidadeLeilao(
      double valorProposta, String objectIdProLeilao, BuildContext context,
      {String? objectIdLeilao}) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Tem certeza"),
            content: Text("Confirme o valor antes de enviar. Continuar?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Não"),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    sendProgressIndicator(true);
                    Get.back();

                    //Consulta a proposta de leilao onde a coluna winLeilao for true (verdadeiro)
                    final queryLastWin =
                        QueryBuilder(ParseObject("PropostaLeilao"))
                          //..whereEqualTo("winLeilao", true)
                          ..whereEqualTo("leilao",
                              ParseObject("Leilao")..objectId = objectIdLeilao)
                          //Ordena a consulta por ordem crescente a partir da coluna valorProposta
                          ..orderByAscending("valorProposta")
                          ..whereEqualTo("entidadeDone", true);

                    // Retorna o primeiro objecto da consulta montada e configura como falso
                    final responseLastWin = await queryLastWin.find();
                    if (responseLastWin.isNotEmpty) {
                      responseLastWin[0].set("winLeilao", false);

                      await responseLastWin[0].save();
                    }

                    //Pega uma nova instancia do parse objecto da classe PropostaLeilao e salva a proposta do leilao

                    final propostaLeilao = ParseObject("PropostaLeilao")
                      ..set("entidadeDone", true)
                      ..set("winLeilao", false)
                      ..set("valorProposta", valorProposta)
                      ..objectId = objectIdProLeilao;

                    //Salva uma nova proposta de leilao
                    await propostaLeilao.save();

                    // Nova instancia de consulta da classe PropostaLeilao
                    final queryLeilao =
                        QueryBuilder(ParseObject("PropostaLeilao"))
                          // Onde a coluna leilao for igual ao objectIdLeilao
                          ..whereEqualTo("leilao",
                              ParseObject("Leilao")..objectId = objectIdLeilao)
                          // Ordena a consulta por ordem crescente a partir da coluna valorProposta
                          ..orderByAscending("valorProposta")
                          // Onde a coluna entidadeDone for igual a true (verdadeiro)
                          ..whereEqualTo("entidadeDone", true);

                    final responseLeilao = await queryLeilao.find();
                    if (responseLeilao.isNotEmpty) {
                      // Configura como verdadeiro o resultado da consulta
                      responseLeilao[0].set("winLeilao", true);
                      await responseLeilao[0].save();
                    }

                    showMessage(
                        context, "A sua proposta foi envida com sucesso!");
                  } catch (e) {
                    Get.snackbar("Erro", "Mensagem: $e");
                    Get.back();
                  } finally {
                    sendProgressIndicator(false);
                  }
                },
                child: Text("Sim"),
              ),
            ],
          );
        });
  }

  // Função que retorna lista de todas as propostas respondidas pelo profissional
  Future<List<ParseObject>> adminLeilaoResponseEntidade(
      String objectIdLeilao) async {
    try {
      final query = QueryBuilder(ParseObject("PropostaLeilao"))
        ..includeObject(["leilao", "leilao.cliente", "entidade"])
        ..whereEqualTo(
            "leilao", ParseObject("Leilao")..objectId = objectIdLeilao)
        ..whereEqualTo("entidadeDone", true);
      final response = await query.query();
      if (response.results != null && response.success) {
        return response.results! as List<ParseObject>;
      }
      return [];
    } catch (e) {
      Get.snackbar("Erro", "Mensagem: $e");
      return [];
    }
  }

  var pdfLoading = false.obs;

  int intPDF = 0;
  Future<String> loadPdf(String url) async {
    var response = await Dio().get(url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0));
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/$intPDF.pdf");
    file.openWrite();
    await file.writeAsBytes(response.data);

    intPDF++;
    return file.path;
  }

  @override
  void onInit() async {
    startPropostaLeilao();
    pdfLoading.value = false;
    super.onInit();
  }

  void showMessage(BuildContext context, String value) async {
    // final channel = WebSocket.connect("");
    // final client = ParseDioClient();
    //LiveQuery liveQuery = new LiveQuery();
    //final query = QueryBuilder(ParseObject("Teste"));
    //final subscription = await liveQuery.client.subscribe(query);
    //subscription.on(LiveQueryEvent.create, (ParseObject value){

    //});
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Sucesso"),
            content: Text(value),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("OK"))
            ],
          );
        });
    Get.back();
  }

  @override
  void onClose() {
    liveQueryPropostaLeilao.client.unSubscribe(subPropostaLeilao);
    super.onClose();
  }
}
