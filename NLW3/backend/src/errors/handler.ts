import { ErrorRequestHandler } from 'express'

const errorHandler: ErrorRequestHandler = (error, request, response, next) => {
    console.error(error);

    return response.status(500).json( { message: 'Erro interno do servidor ' })


};


export default errorHandler;