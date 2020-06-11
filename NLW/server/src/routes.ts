import express from 'express';

import PointsControllers from './controllers/pointControllers';
import ItemsControllers from './controllers/itemsController';

const routes = express.Router();
const pointcontrollers = new PointsControllers();
const itemscontrollers = new ItemsControllers();

routes.get('/itens', itemscontrollers.index);
    
routes.get('/points/:id', pointcontrollers.show);

routes.get('/points', pointcontrollers.index);

routes.post('/points', pointcontrollers.create);

export default routes;