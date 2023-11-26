// retorna a data formatada como string
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  //Timestamp é o objeto que obtemos do Firebase
  //então para exibi-lo, vamos convertê-lo para uma String.
  DateTime dateTime = timestamp.toDate();

  //pegando ano
  String year = dateTime.year.toString();

  //pegando mês
  String month = dateTime.month.toString();

  //pegando dia
  String day = dateTime.day.toString();

  //data formatada
  String formattedData = '$day/$month/$year';

  return formattedData;
}
