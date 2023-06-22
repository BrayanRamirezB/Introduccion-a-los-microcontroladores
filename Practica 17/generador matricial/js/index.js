/*
  Autor: Jose Antonio Guzman Garcia
  Contacto: JAGuzmanMX@outlook.com
  Fecha: 30 de mayo de 2018
  Licencia: GNU General Public License.
*/

function seleccion(id) {
  var elemento = document.getElementById(id);
  elemento.classList.toggle('apagado');
  elemento.classList.toggle('encendido');
};

function codigoAnodo() {
  var filas = 7;
  var columnas = 5;

  //Obtencion del codigo para las filas
  for (var f = 1; f <= filas; f++) {
    var valor = 0;
    for (var c = 1; c <= columnas; c++) {
      var celda = "a" + f.toString() + c.toString();
      if ( document.getElementById( celda ).classList.contains('apagado') )
          valor += Math.pow( 2, ( c - 1) );
      if (valor >= 16)
        document.getElementById("RF" + f.toString() ).innerHTML = "0x" + valor.toString(16);
      else
        document.getElementById("RF" + f.toString() ).innerHTML = "0x0" + valor.toString(16);
    };
  };

  //Obtencion del codigo para las columnas
  for (var c = 1; c <= columnas; c++) {
    var valor = 0;
    for (var f = 1; f <= filas; f++) {
      var celda = "a" + f.toString() + c.toString();
      if ( document.getElementById( celda ).classList.contains('encendido') )
          valor += Math.pow( 2, ( f - 1) );
      if (valor >= 16)
        document.getElementById("RC" + c.toString() ).innerHTML = "0x" + valor.toString(16);
      else
        document.getElementById("RC" + c.toString() ).innerHTML = "0x0" + valor.toString(16);
    };
  };
};

function codigoCatodo() {
  var filas = 7;
  var columnas = 5;

  //Obtencion del codigo para las filas
  for (var f = 1; f <= filas; f++) {
    var valor = 0;
    for (var c = 1; c <= columnas; c++) {
      var celda = "c" + f.toString() + c.toString();
      if ( document.getElementById( celda ).classList.contains('encendido') )
          valor += Math.pow( 2, ( c - 1) );
      if (valor >= 16)
        document.getElementById("cRF" + f.toString() ).innerHTML = "0x" + valor.toString(16);
      else
        document.getElementById("cRF" + f.toString() ).innerHTML = "0x0" + valor.toString(16);
    };
  };

  //Obtencion del codigo para las columnas
  for (var c = 1; c <= columnas; c++) {
    var valor = 0;
    for (var f = 1; f <= filas; f++) {
      var celda = "c" + f.toString() + c.toString();
      if ( document.getElementById( celda ).classList.contains('apagado') )
          valor += Math.pow( 2, ( f - 1) );
      if (valor >= 16)
        document.getElementById("cRC" + c.toString() ).innerHTML = "0x" + valor.toString(16);
      else
        document.getElementById("cRC" + c.toString() ).innerHTML = "0x0" + valor.toString(16);
    };
  };
};
