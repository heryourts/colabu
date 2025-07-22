class EstudiantePerfil {
  final String uid;
  final String nombre;
  final String apellido;
  final String email;
  final String universidadId;
  final String universidadNombre;
  final String carreraId;
  final String carreraNombre;
  final bool verificado;
  final String? fotoUrl;

  EstudiantePerfil({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.universidadId,
    required this.universidadNombre,
    required this.carreraId,
    required this.carreraNombre,
    required this.verificado,
    this.fotoUrl,
  });

  factory EstudiantePerfil.fromMap(Map<String, dynamic> data) {
    return EstudiantePerfil(
      uid: data['uid'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      email: data['email'],
      universidadId: data['universidadId'],
      universidadNombre: data['universidadNombre'],
      carreraId: data['carreraId'],
      carreraNombre: data['carreraNombre'],
      verificado: data['verificado'] ?? false,
      fotoUrl: data['fotoUrl'], // Puede no existir en el documento inicialmente
    );
  }
  EstudiantePerfil copyWith({
    String? uid,
    String? nombre,
    String? apellido,
    String? email,
    String? universidadId,
    String? universidadNombre,
    String? carreraId,
    String? carreraNombre,
    bool? verificado,
    String? fotoUrl,
  }) {
    return EstudiantePerfil(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      universidadId: universidadId ?? this.universidadId,
      universidadNombre: universidadNombre ?? this.universidadNombre,
      carreraId: carreraId ?? this.carreraId,
      carreraNombre: carreraNombre ?? this.carreraNombre,
      verificado: verificado ?? this.verificado,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}
