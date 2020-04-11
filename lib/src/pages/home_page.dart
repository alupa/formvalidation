import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado(context, productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado(BuildContext context, ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
        
        final productos = snapshot.data;

        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, i) => _crearItem(context, productosBloc, productos[i]),
        );
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null ) 
             ? Image(image: AssetImage('assets/no-image.png'))
             : FadeInImage(
               image: NetworkImage(producto.fotoUrl),
               placeholder: AssetImage('assets/jar-loading.gif'),
               height: 250.0,
               width: double.infinity,
               fit: BoxFit.cover
             ),
             ListTile(
               title: Text('${producto.titulo} - ${producto.valor}'),
               subtitle: Text(producto.id),
               onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
             )
      
          ],
        ),
      ),
    );
  }
}
