# lib/aes.rb
require "base64"
module AesRuby
    S_BOX = [
        0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
        0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
        0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
        0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
        0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
        0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
        0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
        0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
        0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
        0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
        0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
        0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
        0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
        0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
        0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
    ].freeze

    INV_S_BOX = [
        0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
        0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
        0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
        0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
        0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
        0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
        0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
        0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
        0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
        0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
        0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
        0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
        0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
        0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
        0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
        0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
    ].freeze

    R_CON = [
        [0x00, 0x00, 0x00, 0x00],
        [0x01, 0x00, 0x00, 0x00],
        [0x02, 0x00, 0x00, 0x00],
        [0x04, 0x00, 0x00, 0x00],
        [0x08, 0x00, 0x00, 0x00],
        [0x10, 0x00, 0x00, 0x00],
        [0x20, 0x00, 0x00, 0x00],
        [0x40, 0x00, 0x00, 0x00],
        [0x80, 0x00, 0x00, 0x00],
        [0x1b, 0x00, 0x00, 0x00],
        [0x36, 0x00, 0x00, 0x00]
    ].freeze
    
    class << self
    
        def times_x(hex_number)
            # left shift the input by one bit
            left_shifted = hex_number << 1
            
            if (left_shifted & 0b100000000) == 0b100000000
              # XOR with reducing polynomial
              result = left_shifted ^ 0b100011011
            else
              # dont reduce further if b7 is 0
              result = left_shifted
            end
            # return a binary string since ruby returns a int base 10
            return result
        end
          
        def sub_bytes(state)
            rows = state.size
            columns = state[0].size
            (0..rows-1).each do |i|
              (0..columns-1).each do |j|
                value = state[i][j]
                sub_value = AesRuby::S_BOX[value]
                state[i][j] = sub_value
              end
            end
            return state
        end
    
        def shift_rows(state)
            (0..3).each do |row|
              if row != 0
                state[row] = state[row].rotate(row)
              end
            end
            return state
        end
    
        def multiply(a, b)
            len = b.to_s(2).size
            reduction = 0
            intermediateXtime = a
            for i in (0..len-1) do
              is_positive = b&(2**i) > 0
              
              # puts intermediateXtime.to_s(16)
              if is_positive
                reduction ^= intermediateXtime
              end
              intermediateXtime = times_x(intermediateXtime)
            end
            #puts "final answer #{reduction.to_s(16)}"
            return reduction
        end
    
        def mix_columns(state)
            matrix = [
              [0x02, 0x03, 0x01, 0x01],
              [0x01, 0x02, 0x03, 0x01],
              [0x01, 0x01, 0x02, 0x03],
              [0x03, 0x01, 0x01, 0x02]
            ]
          
            s_prime = Array.new(4) { Array.new(4, 0)}
            cols = state[0].size
            for j in (0..3) do
              for i in (0..3) do
                m1, m2, m3, m4 = matrix[i][0], matrix[i][1], matrix[i][2], matrix[i][3]
                s1, s2, s3, s4 = state[0][j], state[1][j], state[2][j], state[3][j]
                s_prime[i][j] = multiply(m1, s1) ^ multiply(m2, s2) ^ multiply(m3, s3) ^ multiply(m4, s4)
              end
            end
            return s_prime
        end
    
        def key_expansion(key, s_box, r_con)
            n_r = 10
            n_b = 4
            n_k = 4  
            
            w = key.each_slice(n_k).to_a
            i = n_k
          
            while i < n_b*(n_r + 1) do
              temp = w[i-1]
              if i % n_k == 0
                temp = xor(sub_word(temp.rotate(1), s_box), r_con[i/n_k])
              elsif ((n_k > 6) && (i % n_k == 4))
                temp = sub_word(temp)
              end
              w[i] = xor(w[i-n_k], temp)
              i += 1
            end 
            return w
        end
    
        def xor(arr1, arr2)
            raise StandardError.new("Can't perform XOR, byte arrays not the same size") if arr1.length != arr2.length
            xor_result = []
            for i in (0..arr1.length-1) do
              xor_result[i] = arr1[i] ^ arr2[i]
            end
            xor_result
        end
    
        def sub_word(word, s_box)
            (0..3).each do |i|
              word[i] = s_box[word[i]]
            end
            word
        end
    
        def add_round_key(state, key_expansion)
            new_state = Array.new(4) { [] }
            for i in (0..3) do
              new_state[i] = xor(state[i], key_expansion[i])
            end
            new_state
        end
    
        def format_matrix(matrix)
            matrix.map do |row|
              s = ""
              row.map do |e|
                s += "#{e.to_s(16)},"
              end
              puts "#{s}"
            end
        end
          
        def parse(array)
            array.each_slice(4).to_a.transpose
        end
    
        # @param [Array] input The input to be encrypted as a byte array
        # @param [Array] key The encryption key as a byte array
        def encrypt_block(input, key)
            state = parse(input)
            n_b = 4
            n_r = 10
            n_k = 4
            
            w = key_expansion(key, AesRuby::S_BOX, AesRuby::R_CON)
            state = add_round_key(state, w[0, 4].transpose)
    
            for i in (1..n_r-1)
              state = sub_bytes(state)
              state = shift_rows(state)
              state = mix_columns(state)
              state = add_round_key(state, w.slice(i*n_b, 4).transpose)
            end
            
            state = sub_bytes(state)
            state = shift_rows(state)
            state = add_round_key(state, w.slice(n_r*n_b, 4).transpose)
            state
        end
    
        def inv_shift_rows(state)
            (0..3).each do |row|
              if row != 0
                state[row] = state[row].rotate(-row)
              end
            end
            return state
        end
    
        def inv_sub_bytes(state)
            rows = state.size
            columns = state[0].size
            (0..rows-1).each do |i|
              (0..columns-1).each do |j|
                value = state[i][j]
                sub_value = AesRuby::INV_S_BOX[value]
                state[i][j] = sub_value
              end
            end
            return state
        end
    
        def inv_mix_columns(state)
            matrix = [
              [0x0e, 0x0b, 0x0d, 0x09],
              [0x09, 0x0e, 0x0b, 0x0d],
              [0x0d, 0x09, 0x0e, 0x0b],
              [0x0b, 0x0d, 0x09, 0x0e]
            ]
          
            s_prime = Array.new(4) { Array.new(4, 0)}
            cols = state[0].size
            for j in (0..3) do
              for i in (0..3) do
                m1, m2, m3, m4 = matrix[i][0], matrix[i][1], matrix[i][2], matrix[i][3]
                s1, s2, s3, s4 = state[0][j], state[1][j], state[2][j], state[3][j]
                s_prime[i][j] = multiply(m1, s1) ^ multiply(m2, s2) ^ multiply(m3, s3) ^ multiply(m4, s4)
              end
            end
            return s_prime
        end
    
        # @param [Array] input The ciphertext to be decrypted as a byte array
        # @param [Array] key The encryption key as a byte array
        def decrypt_block(input, key)
            state = parse(input)
            w = key_expansion(key, AesRuby::S_BOX, AesRuby::R_CON)
    
            n_b = 4
            n_r = 10
            n_k = 4
            state = add_round_key(state, w.slice(n_r*n_b, 4).transpose)
            (n_r - 1).downto(1).each do |i|
              state = inv_shift_rows(state)
              state = inv_sub_bytes(state)
              state = add_round_key(state, w.slice(i*n_b, 4).transpose)
              state = inv_mix_columns(state)
            end
    
            state = inv_shift_rows(state)
            state = inv_sub_bytes(state)
            state = add_round_key(state, w[0, 4].transpose)
            
            state
        end
    
        # @param [String] plaintext The plaintext to be encrypted as a string
        # @param [String] key The encryption key as a string
        # @param [String] mode The mode of operation. eg: 'CBC' or 'ECB' etc
        def encrypt(plaintext, key, mode, iv=[])
            key_bytes = key.bytes
            blocks = plaintext.bytes.each_slice(16).to_a.tap { |a| a.last.fill(0, a.last.length, key_bytes.size - a.last.length)}
            case mode
            when 'CBC'
              output_block = iv
              encrypted_bytes = []
              for block in blocks do
                current_input = xor(block, output_block)
                encrypted_matrix = AesRuby.encrypt_block(current_input, key_bytes)
                encrypted_array = encrypted_matrix.transpose.flatten
                encrypted_bytes << encrypted_array
                output_block = encrypted_array
              end
              encrypted_bytes.flatten
            else
              # default to ECB mode
              encrypted_bytes = []
              blocks.map do |block|
                encrypted_matrix = AesRuby.encrypt_block(block, key_bytes)
                encrypted_array = encrypted_matrix.transpose.flatten
                encrypted_bytes << encrypted_array
              end
              hex = encrypted_bytes.flatten
            end
        end
    
          # @param [String] ciphertext_bytes The ciphertext to be decrypted as a Base64 Encoded string
          # @param [String] key The encryption key as a string
          # @param [String] mode The mode of operation. eg: 'CBC' or 'ECB' etc
        def decrypt(ciphertext_bytes, key, mode='ECB', iv=[])
            key_bytes = key.bytes
            decoded_cipher_bytes_array = ciphertext_bytes
            blocks = decoded_cipher_bytes_array.each_slice(16).to_a.tap { |a| a.last.fill(0, a.last.length, key_bytes.size - a.last.length)}
            case mode 
            when 'CBC'
              decrypted_output = []
              (blocks.length - 1).downto(1) do |i|
                decrypted_matrix = AesRuby.decrypt_block(blocks[i], key_bytes)
                output_block = blocks[i-1]
                decrypted_output << xor(decrypted_matrix.transpose.flatten, output_block)
              end
              decrypt_first_block = AesRuby.decrypt_block(blocks[0], key_bytes)
              decrypted_output << xor(decrypt_first_block.transpose.flatten, iv)
              decrypted_output.reverse.flatten
    
            else
              # default ECB mode
              decrypted_output = []
              blocks.map do |block|
                decrypted_matrix = AesRuby.decrypt_block(block, key_bytes)  
                decrypted_output << decrypted_matrix.transpose.flatten
              end
              decrypted_output.flatten
            end
        end
    end
end
  