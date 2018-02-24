require './dust.rb'
require './post_for_line.rb'

def start
  dust = Dust.new
  recycleDay = dust.recycleDay()
  puts("day : #{recycleDay}")
  line = PostForLine.new
  line.post("#{0x1F42E.chr('UTF-8')} 明日は#{recycleDay}の日だよ。忘れずに捨てよう！ ﾓ〜＞ #{0x1F404.chr('UTF-8')}")
end

start
