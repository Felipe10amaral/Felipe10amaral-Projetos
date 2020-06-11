import knex from '../database/connection';
import { Request, Response} from 'express';

class PointControllers {

    async index(req: Request, res: Response) {
        
        const { city, uf, items} = req.query;

       

        const parsedItems = String(items).split(',').map(item => Number(item.trim()));

        const points = await knex('points')
            .join('point_items', 'points.id', '=', 'point_items.point_id')
            .whereIn('point_items.item_id', parsedItems)
            .where('city', String(city))
            .where('uf', String(uf))
            .distinct()
            .select('points.*');



        return res.json( points);
    }

    async show(req: Request, res:Response) {
        const { id } = req.params;
        
        const point = await knex('points').where('id', id).first();

        if(!point) {
            return res.status(400).json( {message: "Ponto não encontrado"});

        }

        const items = await knex('items')
        .join('point_items', 'items.id', '=', 'point_items.item_id')
        .where('point_items.point_id', id)
        .select('items.title');
        /* 
            .join('point_items', 'item.id', '=', 'point_items.item_id')
            .where('point_items.point_id', id); */


            return res.json( {point, items });
        
    }

    async create (req: Request, res:Response)  {
        const {
            name,
            email,
            whatsapp,
            latitude,
            longitude,
            city,
            uf,
            items
        } = req.body;
        

        const ids = await knex('points').insert({
            image: 'image-fake',
            name,
            email,
            whatsapp,
            latitude,
            longitude,
            city,
            uf
        });
        const data = ids;

        const pointItems = items.map( (item_id: number) => {
            return {
                item_id,
                point_id: ids[0],
            }
        })

        await knex('point_items').insert(pointItems);

        return res.json( {
            ...data,
        }
        );


    
        /* const trx = await knex.transaction();

        const point = {
            image: 'image-fake',
            name,
            email,
            whatsapp,
            latitude,
            longitude,
            city,
            uf
        };
    
        const insertId = await trx('points').insert(point);
    
        const point_id = insertId[0];
    
        const pointItems = items.map((item_id: number) => {
            return {
                item_id,
                point_id
            }
        })
    
        await trx('point_items').insert(pointItems);
    
        return res.json({ 
            id: point_id,
            ...point,
        });  */
    } 
}

export default PointControllers;