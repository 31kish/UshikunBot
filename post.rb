require 'date'
require 'time'
require 'bundler'
Bundler.require

# クラスPostの宣言
class Post
  def recycleDay
    # 現在の曜日を確認し、その曜日のゴミの日を返す
    dust = checkDust(checkWeekDay)
    # dustがnilではないとき
    if dust.nil?
      puts('該当なし')
    else
      puts("明日は" + dust + "の日だよ。忘れずに捨てよう！")
      slack = Slack::Incoming::Webhooks.new ENV['POST_URL'], channel: 'general'
      slack.post(":cow: 明日は" + dust + "の日だよ。忘れずに捨てよう！ ﾓ〜＞ :cow2:")
    end
  end

  private
  # 現在の曜日を確認
  def checkWeekDay
    wdays = ["日", "月", "火", "水", "木", "金", "土"]
    today = Date.today + 1

    # TEST
    # today = Date.strptime("2016年06月17日", "%Y年%m月%d日")

    if wdays[today.cwday] == "金"
      if week_of_month(today).eql?(1)
        return "第1金曜"
      elsif week_of_month(today).eql?(3)
        return "第3金曜"
      elsif week_of_month(today).eql?(4)
        return "第4金曜"
      end
    else
      return wdays[today.wday]
    end
  end

  # 現在は何週目か確認
  def week_of_month(date)
    # 指定された日付が、その月において何週目にあたるのかを計算し返します。
    # 週始まりは月曜です。初週は１とする。
    first_week = (date - (date.day)).cweek
    this_week = date.cweek
    # 年末は暦週が１になったり、逆に年始に暦週が５３になることがあるため、その対処は以下で行う。
    if this_week < first_week
      if date.month == 12
        # 年末の場合は、前の週と同じ曜日の週番号を求めて、＋１する
        # ここを通ることがるのは、大晦日とその前数日となる
        return week_of_month(date - 7) + 1
      else
        # 年始の場合は、月初の数日が53週めに組み込まれてしまっている
        # 2週目以降にここを通ることがある
        return this_week + 1
      end
    end
    return this_week - first_week + 1
  end

  # ゴミの日定義
  def checkDust(week_day)
    if week_day == "月" || week_day == "木"
      return "焼却ゴミ"
    elsif week_day == "水"
      return "プラスチック・ペットボトル・缶・ビン"
    elsif week_day == "第1金曜" || week_day == "第3金曜"
      return "紙・紙パック・ダンボール・新聞・雑誌・布類"
    elsif week_day == "第4金曜"
      return "金属・ガラス・せともの・有害危険ゴミ"
    end
  end
end
