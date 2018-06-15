require 'base64'
require 'openssl'
require 'securerandom'

module Jindouyun
  class MessageEncryptor

    BLOCK_SIZE = 32

    attr_reader :encoding_aes_key, :sign_token, :app_id

    def initialize(encoding_aes_key: nil, sign_token: nil, app_id: nil)
      @encoding_aes_key = encoding_aes_key
      @sign_token = sign_token
      @app_id = app_id
    end

    def encrypt(payload)
      aes_encrypt(payload).delete("\n")
    end

    def encrypt_with_signature(payload)
      encrypted_payload = encrypt(payload)
      timestamp = Time.now.to_i.to_s
      nonce = SecureRandom.hex(8)
      signature = generate_signature(encrypted_payload, timestamp, nonce)
      return [encrypted_payload, timestamp, nonce, signature]
    end

    def encrypt_to_json(payload)
      encrypted_payload, timestamp, nonce, signature = encrypt_with_signature(payload)
      {
        msg_signature: signature,
        timeStamp: timestamp,
        nonce: nonce,
        encrypt: encrypted_payload
      }
    end

    def decrypt(payload)
      encrypted_payload = payload['echostr'] || payload['encrypt']
      sign = generate_signature encrypted_payload, payload['timeStamp'], payload['nonce']
      message, app_id = decrypt_payload encrypted_payload
      return message, app_id, sign
    end

    def aes_decrypt(encrypted_message)
      message, _app_id = decrypt_payload(encrypted_message)
      message
    end

    private

    def aes_key
      @aes_key ||= Base64.decode64 encoding_aes_key + '='
    end

    def decrypt_payload(encrypted_payload)
      text = Base64.decode64 encrypted_payload
      text = handle_cipher(:decrypt, text)
      result = pkcs7_decode(text)
      content = result[16...result.length]
      len_list = content[0...4].unpack('N')
      xml_len = len_list[0]
      payload = content[4...4 + xml_len]
      app_id = content[xml_len+4...content.size]
      return payload, app_id
    end

    def generate_signature(message, timestamp, nonce)
      sorted_params = [message, sign_token, timestamp, nonce].sort.join
      Digest::SHA1.hexdigest(sorted_params)
    end

    def aes_encrypt(text)
      text = text.force_encoding('ASCII-8BIT')
      random = SecureRandom.hex(8)
      msg_len = [text.length].pack('N')
      text = "#{random}#{msg_len}#{text}#{app_id}"
      text = encode(text)
      text = handle_cipher(:encrypt, text)
      Base64.encode64(text)
    end

    def handle_cipher(action, text)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.send(action)
      cipher.padding = 0
      cipher.key = aes_key
      cipher.iv = aes_key[0...16]
      cipher.update(text) + cipher.final
    end

    def pkcs7_decode(text)
      pad = text[-1].ord
      pad = 0 if pad < 1 || pad > BLOCK_SIZE
      size = text.size - pad
      text[0...size]
    end

    def encode(text)
      amount_to_pad = BLOCK_SIZE - (text.length % BLOCK_SIZE)
      amount_to_pad = BLOCK_SIZE if amount_to_pad.zero?
      pad_chr = amount_to_pad.chr
      "#{text}#{pad_chr * amount_to_pad}"
    end

  end
end
