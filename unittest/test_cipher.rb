require "test/unit"
require "internal/cipher"

class TestCipher < Test::Unit::TestCase

  def test_gcm()
    key = Random::new.bytes(GGEV::CipherGCM::KEY_SIZE)
    data = "helloworld"
    auth_data = {"somekey": "someval"}

    ecipher = GGEV::CipherGCM.new(key)
    encrypted_data = ecipher.encrypt(data, auth_data)

    dcipher = GGEV::CipherGCM.new(key)
    decrypted_data = dcipher.decrypt(encrypted_data, auth_data)

    assert(false) if data!=decrypted_data
    assert(true)
  end
end
