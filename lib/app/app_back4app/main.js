Parse.Cloud.define("hello", (request) => {
    console.log("Hello from Cloud Code!");
    return "Nelton Menata - O Programador";
});

Parse.Cloud.define("soma", async (request) => {

    return request.params.num1 + request.params.num2;

});

Parse.Cloud.beforeSave("PropostaLeilao", (request)=>{
    ///
});
Parse.Cloud.afterSave("PropostaLeilao", async (request)=>{
    ///
    const id = request.object.get("objectId");
    const query = new Parse.Query("PropostaLeilao");
    query.orderByAscending("");
    let results = await query.find();

});
