const express = require('express');
const cors = require('cors');
const routes = require('./routes');

const app = express();

app.use(cors());

app.use(express.json());
app.use(routes);
app.listen(3333);

/*  Tipos de Parametros
    
    Query Params: Parametros nomeados enviados na rota após "?" (Utlizados para filtros , paginação ...)

    Route Params: Parametros utilizados para identificar recursos( Identifica geralmente um unico recurso)

    Request Body: Corpo da requisição, utilizado para criar ou alterar recursos

*/
