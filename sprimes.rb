# Init Data
@dataload_thread = Thread.new {
    b0 = File.read("primes_0B.bin").unpack("B*").first
    # b1 = File.read("primes_0B.bin").unpack("B*").first
    # b2 = File.read("primes_0B.bin").unpack("B*").first
    # b3 = File.read("primes_0B.bin").unpack("B*").first
    @comp = b0 # + b1 + b2 + b3
}

# Compressor Reader
def is_prime(n)
    if n < 2 
        false
    elsif 2 <= n && n <= 5
        {2 => true, 3 => true, 4 => false, 5 => true}[n]
    elsif n % 2 == 0 || n % 5 == 0
        false
    else 
        from_compressed(n)
    end
end


def from_compressed(n)
    if (n % 2 == 0 || n % 5 == 0)
        false
    else
        @dataload_thread.join()

        bucket = (n / 10) * 4 
        offset = {1 => 0, 3 => 1, 7 => 2, 9 => 3}[n % 10]
        str = @comp[bucket + offset]
        !str.to_i.zero?
    end
end

def list(from=2, to=100)
    res = []
    from.upto(to) do |i|
        if is_prime(i)
            res.append(i)
        end
    end
    res
end

puts list(ARGV[0].to_i || 0 , ARGV[1].to_i || 100)