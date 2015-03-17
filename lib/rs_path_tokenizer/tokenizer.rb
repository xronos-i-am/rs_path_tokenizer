module RsPathTokenizer
  class Tokenizer
    PT_DEBUG = false
    # PT_DEBUG = true

    def initialize(tokens = nil)
      return if tokens.nil?
      @single_tokens = {}
      tokens.keys.each do |t|
        parts = url2token(t)
        st = parts[0]
        raise Error.new('Token cant starts with asterisk') if st == '*'
        @single_tokens[st] = [] if @single_tokens[st].nil?
        @single_tokens[st].push parts
      end
      @token_map = tokens
    end

    def marshal_dump
      [@single_tokens, @token_map]
    end

    def marshal_load array
      @single_tokens, @token_map = array
    end

    # best result
    def tokenize(string)
      tokens = tokenize_all(string).first
      return if tokens.nil?

      result_to_hash(tokens)
    end

    protected

      # all results
      def tokenize_all(string)
        array = url2token(string)
        raise Error.new('Too long URL') if array.length > 500
        possible_tokens = Hash[@single_tokens.keys.select do |st|
          array.include?(st)
        end.map do |st|
          [st, @single_tokens[st]]
        end]
        @out_token_map = @token_map
        sort_results(recursive_parse(array, possible_tokens))
      end

      def sort_results(results)
        results.sort do |a, b|
          result = b.flatten.length <=> a.flatten.length
          result = b.length <=> a.length if result == 0
          puts "sorting: #{a.inspect} #{b.inspect} #{result}" if PT_DEBUG
          result
        end
      end

      def result_to_hash(array)
        Hash[array.map do |e|
          k = token2url(e)
          [k, @out_token_map[k]]
        end]
      end

      def recursive_parse(array, possible_tokens, limiter = 1)
        if limiter > 30
          raise Error.new('Too deep recursion')
        end

        st = array.first
        return [] if st.to_s.strip == ''

        tokens = possible_tokens[st]
        if tokens.nil?
          puts "#{"  " * limiter}NO tokens for #{st}" if PT_DEBUG
          return recursive_parse(array.slice(1..-1), possible_tokens)
        end

        results = []
        puts "#{"  " * limiter}possible tokens for #{st} are: #{tokens.inspect}" if PT_DEBUG

        tokens.each do |token|
          found, out, rest = try_match(token, array)
          puts "#{"  " * limiter}matching #{token.inspect}" if PT_DEBUG

          if found
            if out != token
              @out_token_map[token2url(token)] = out
            end

            puts "#{"  " * limiter}found a token: #{token.inspect}, parsing rest: #{rest.inspect}" if PT_DEBUG
            more = recursive_parse(rest.dup, possible_tokens, limiter + 1)
            results = merge_results(results, token, more)

          else
            puts "#{"  " * limiter}found none on this level, NOT parsing rest: #{rest.inspect}" if PT_DEBUG
            more = recursive_parse(array.dup.slice(1..-1), possible_tokens, limiter + 1)
            results = merge_results(results, nil, more)
          end
        end

        if PT_DEBUG
          puts "#{"  " * limiter}results:"
          results.each do |r|
            puts "#{"  " * limiter}  #{r.inspect}"
          end
        end

        results
      end

      def merge_results(results, found, other)
        if other.empty?
          unless found.nil?
            results.push [found]
          end
        else
          if found.nil?
            other.each do |o|
              results.push o
            end
          else
            other.each do |o|
              results.push [found] + o
            end
          end
        end
        results.map(&:uniq).uniq
      end

      def try_match(token, array)
        found, out = [], []
        rest = array.dup

        token.each do |token_part|
          url_part = rest.shift
          break if url_part.nil?

          if token_part == '*'
            out.push url_part
            found.push token_part

          elsif token_part == url_part
            found.push token_part
            out.push token_part
          end
        end

        if found == token
          [true, out, rest]
        else
          [false, out, array]
        end
      end

      def token2url(token)
        token.join('-')
      end
      def url2token(url)
        url.split("-")
      end
  end
end
