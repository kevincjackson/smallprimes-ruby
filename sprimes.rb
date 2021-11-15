require "json"

# Usage
#   sprimes is 7    # true
#   sprimes info 7  # { number: 7, is_prime: true, position: 4 }
#   sprimes info 77 # { number: 77, is_prime: false, position: nil }
#   sprimes pos 4   # 7
#   sprimes list    # [2, 3, 5, 7, 11, ..., 97] 
# Commands:     `is n`, `info n`, `list`, `pos i`, `rand`
# Query:        `-f --from`, `-t --to`, `--from-pos`, `--to-pos`
# Info:         -> `{ number: int, is_prime: bool, position: int }`

# Init Data
@dataload_thread = Thread.new {
    b0 = File.read("primes_0B.bin").unpack("B*").first
    # b1 = File.read("primes_0B.bin").unpack("B*").first
    # b2 = File.read("primes_0B.bin").unpack("B*").first
    # b3 = File.read("primes_0B.bin").unpack("B*").first
    @data = b0 # + b1 + b2 + b3
}

# int -> bool
def from_data(n)
    if (n % 2 == 0 || n % 5 == 0)
        false
    else
        @dataload_thread.join()

        bucket = (n / 10) * 4 
        offset = {1 => 0, 3 => 1, 7 => 2, 9 => 3}[n % 10]
        str = @data[bucket + offset]
        !str.to_i.zero?
    end
end

# Compressor Reader
def is_prime(n)
    if n < 2 
        false
    elsif 2 <= n && n <= 5
        {2 => true, 3 => true, 4 => false, 5 => true}[n]
    elsif n % 2 == 0 || n % 5 == 0
        false
    else 
        from_data(n)
    end
end

# int, int -> [int]
def list(from=2, to=100)
    res = []
    from.upto(to) do |i|
        if is_prime(i)
            res.append(i)
        end
    end
    res
end

# int -> int || nil
def pos_to_prime(i)
    # init
    @dataload_thread.join()
    target = i.to_i
    count = 0
    res = nil

    # go through numbers until you hit count
    2.upto(@data.size - 1) do |number|
        if is_prime(number)
            count += 1
            if count == target
                res = number 
                break
            end
        end
    end
    res
end

# int -> int || nil
def prime_to_pos(num)
    if is_prime(num)
        count = 0
        2.upto(num) do |i|
            if is_prime(i)
                count += 1
            end
        end
        count
    else
        nil
    end
end

# int -> {}
def info(num)
    { 
        number: num, 
        is_prime: is_prime(num),
        position: prime_to_pos(num)
    }
end
