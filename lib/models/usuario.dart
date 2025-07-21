class Usuario {
  final String uid;
  final String email;
  final String nombre;
  final String tipo; // 'alumno' o 'tutor'

  Usuario({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'nombre': nombre, 'tipo': tipo};
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      email: map['email'],
      nombre: map['nombre'],
      tipo: map['tipo'],
    );
  }
}
