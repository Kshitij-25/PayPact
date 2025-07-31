class RegexConstants {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp nameRegex = RegExp(
    r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$",
  );

  static final RegExp amountRegex = RegExp(
    r'^\d+\.?\d{0,2}$',
  );

  static final RegExp phoneRegex = RegExp(
    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
  );
}
