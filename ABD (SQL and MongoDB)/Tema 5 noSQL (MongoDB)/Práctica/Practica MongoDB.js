AP2
1.- db.aficiones.find({Puntuación:{$gte:9}});
db.aficiones.aggregate([{$match:{puntuacion:{$gte:9}}},{$group:{_id:”$Tema”, nombre: {$addtoset:{Nombre:”$Nombre”}Puntuacion

db.aficiones.aggregate([{$match: {puntuacion: {gte:9}}},
			{$group:{_id:”$tema”, 
					total: {$sum:”$precio”},
					contamos: {$sum:1}

3.- db.aficiones.aggregate([{$match:{$or:[{Puntuacion:{$eq:5}{$eq:6}{$eq:7}{$eq:8}{$eq:9}{$eq:10}]

{$group:{_id:{Tema:”$tema”,Puntuación:”$puntuacion”},Nombres:{$addtoset:{nombre:”$nombre”}}

}}
{$sort:{“_id.Tema”:1}}])

/////////////////////////////////////////////////
e) aggregate($group{_id : "$Tema"}, count : {$sum : 1}, docs : {$push : "$Nombre"}).forEach(function(myDoc) { print (myDoc) }) .....

f) update({"Puntuacion" : {$lt:7}}), {$mul : {"Precio" : 0.9}}, false, false}

g) ...aggregate([{$unwind : {"$Componentes"}, {$sort : {"Componentes.Componente.Precio.1"}}]).forEach(function (myDoc));

//Otra cosa:
find(...).forEach(function (myDoc) {
	var descuento = ... *;
	myDoc.Descuento = ...;
	myDoc.Precio = ...;
	...save(myDoc);
})

AP3
...createCollection("superGuai", {capped : true, size : 100000, max : 5, autoIndexId : true});