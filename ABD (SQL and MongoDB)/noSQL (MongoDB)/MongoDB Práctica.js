db.aficiones.aggregate(
    [
        {$match: {Puntuacion: {$gte:9}}},
        {$group: 
            {_id:"$tema",
                {nombre:
                    {$addtoset:
                        {Nombre: "$Nombre"
                        }Puntuacion
                    }
                }
            }
        }
    ]
)