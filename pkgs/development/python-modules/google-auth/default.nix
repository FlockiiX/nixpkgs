{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cachetools
, flask
, freezegun
, mock
, oauth2client
, pyasn1-modules
, pyu2f
, pytest-localserver
, responses
, rsa
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G6STjgMrc961HlnEZWoA4JOc8LERJXUJnxNrq7RWMxI=";
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    pyu2f
  ];

  checkInputs = [
    flask
    freezegun
    mock
    oauth2client
    pytestCheckHook
    pytest-localserver
    responses
  ];

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_request_with_timeout_success"
    "test_request_with_timeout_failure"
    "test_request_headers"
    "test_request_error"
    "test_request_basic"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # E MemoryError: Cannot allocate write+execute memory for ffi.callback().
    # You might be running on a system that prevents this.
    # For more information, see https://cffi.readthedocs.io/en/latest/using.html#callbacks
    "test_configure_mtls_channel_with_callback"
    "test_configure_mtls_channel_with_metadata"
    "TestDecryptPrivateKey"
    "TestMakeMutualTlsHttp"
    "TestMutualTlsAdapter"
  ];

  meta = with lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google’s various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
