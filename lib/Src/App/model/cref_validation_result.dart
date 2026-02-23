class CrefValidationResult {
  final bool isValid;
  final String? name;
  final String? status;
  final String? uf;
  final String? cref;

  CrefValidationResult({
    required this.isValid,
    this.name,
    this.status,
    this.uf,
    this.cref,
  });

  factory CrefValidationResult.fromJson(Map<String, dynamic> json) {
    return CrefValidationResult(
      isValid: json['isValid'] == true || json['valid'] == true,
      name: json['name']?.toString() ?? json['nome']?.toString(),
      status: json['status']?.toString(),
      uf: json['uf']?.toString(),
      cref: json['cref']?.toString(),
    );
  }
}
