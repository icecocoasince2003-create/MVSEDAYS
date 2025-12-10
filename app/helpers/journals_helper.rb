module JournalsHelper
    def getPercent(number) 
        if number.present?
          calPercent = number/5.to_f * 100
          # calPercent = number/10.to_f * 100 # 十段階評価の場合
          percent = calPercent.round
          # 四捨五入して整数化
          return percent.to_s
        else
          return 0
        end
    end
end