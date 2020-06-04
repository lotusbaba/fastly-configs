sub ak_awsv4_check {
  declare local var.awsAccessKey STRING;
  declare local var.awsSecretKey STRING;
  declare local var.awsRegion STRING;
  declare local var.canonicalHeaders STRING;
  declare local var.signedHeaders STRING;
  declare local var.canonicalRequest STRING;
  declare local var.canonicalQuery STRING;
  declare local var.stringToSign STRING;
  declare local var.dateStamp STRING;
  declare local var.signature STRING;
  declare local var.scope STRING;

  declare local var.x-amz-content-sha256 STRING;
  declare local var.x-amz-date STRING;
  declare local var.host STRING;
  declare local var.url STRING;
  declare local var.Authorization STRING;

  set var.awsAccessKey = table.lookup(mediashield_auth, "access_id");
  set var.awsSecretKey = table.lookup(mediashield_auth, "secret_id");
  set var.awsRegion = "us-east-1";

  if (req.method == "GET" || req.method == "HEAD") {

    set var.x-amz-content-sha256 = req.http.x-amz-content-sha256;
    set var.x-amz-date = req.http.x-amz-date;
    set var.host = "s3.amazonaws.com";
    set var.url = req.url.path;
    set var.dateStamp = regsub (req.http.x-amz-date, "^(\d{8}).*", "\1");
    set var.canonicalHeaders = ""
      "host:" var.host LF
      "x-amz-content-sha256:" var.x-amz-content-sha256 LF
      "x-amz-date:" var.x-amz-date LF
    ;
    # may need review for multiple query parameters
    set var.canonicalQuery = "";
    if (req.url.qs != "") {
      set var.canonicalQuery = req.url.qs + "=";
    }
    set var.signedHeaders = "host;x-amz-content-sha256;x-amz-date";
    set var.canonicalRequest = ""
      req.method LF
      var.url LF
      var.canonicalQuery LF
      var.canonicalHeaders LF
      var.signedHeaders LF
      var.x-amz-content-sha256
    ;

    set var.scope = var.dateStamp "/" var.awsRegion "/s3/aws4_request";

    set var.stringToSign = ""
      "AWS4-HMAC-SHA256" LF
      var.x-amz-date LF
      var.scope LF
      regsub(digest.hash_sha256(var.canonicalRequest),"^0x", "")
    ;

    set var.signature = digest.awsv4_hmac(
      var.awsSecretKey,
      var.dateStamp,
      var.awsRegion,
      "s3",
      var.stringToSign
    );

    set var.Authorization = "AWS4-HMAC-SHA256 "
      "Credential=" var.awsAccessKey "/" var.scope ", "
      "SignedHeaders=" var.signedHeaders ", "
      "Signature=" + regsub(var.signature,"^0x", "")
    ;

    set req.http.isFastlyMediaShielded = "yes";

    # check the calculated vs supplied signatures
    if (var.Authorization != req.http.Authorization) {
      error 400;
    }
  }
}
