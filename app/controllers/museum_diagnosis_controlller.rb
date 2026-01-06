# frozen_string_literal: true

class MuseumDiagnosisController < ApplicationController
  # 診断は誰でも利用可能（ログイン不要）
  skip_before_action :authenticate_user!, only: [:new, :create]

  # 診断ページ
  def new
    # 診断フォームを表示
  end

  # 診断結果
  def create
    # ユーザーの回答を取得
    answers = params[:answers] || {}

    # おすすめの博物館を計算
    @recommended_museums = calculate_recommendations(answers)

    # 診断結果ページを表示
    render :result
  end

  private

  # おすすめの博物館を計算するロジック
  def calculate_recommendations(answers)
    museums = Museum.all
    scored_museums = []

    museums.each do |museum|
      score = 0

      # Q1: 興味がある分野（美術館、博物館、科学館など）
      if answers[:q1].present?
        case answers[:q1]
        when 'art'
          score += 10 if museum.museum_type&.include?('美術館')
        when 'history'
          score += 10 if museum.museum_type&.include?('歴史') || museum.museum_type&.include?('博物館')
        when 'science'
          score += 10 if museum.museum_type&.include?('科学館') || museum.museum_type&.include?('科学')
        when 'nature'
          score += 10 if museum.museum_type&.include?('自然史') || museum.museum_type&.include?('動物園') || museum.museum_type&.include?('水族館')
        when 'culture'
          score += 10 if museum.museum_type&.include?('文化') || museum.museum_type&.include?('民俗')
        end
      end

      # Q2: 行きたい地域
      if answers[:q2].present?
        case answers[:q2]
        when 'tokyo'
          score += 15 if museum.prefecture == '東京都'
        when 'osaka'
          score += 15 if museum.prefecture == '大阪府'
        when 'kyoto'
          score += 15 if museum.prefecture == '京都府'
        when 'hokkaido'
          score += 15 if museum.prefecture == '北海道'
        when 'anywhere'
          score += 5  # どこでもOKの場合は少しプラス
        end
      end

      # Q3: 博物館の規模
      if answers[:q3].present?
        case answers[:q3]
        when 'large'
          score += 5 if museum.registration_type&.include?('国立')
        when 'medium'
          score += 5 if museum.registration_type&.include?('公立')
        when 'small'
          score += 5 if museum.registration_type&.include?('私立')
        when 'any'
          score += 3
        end
      end

      # Q4: 訪問の目的
      if answers[:q4].present?
        case answers[:q4]
        when 'learn'
          score += 5 if museum.museum_type&.include?('博物館') || museum.museum_type&.include?('科学館')
        when 'relax'
          score += 5 if museum.museum_type&.include?('美術館') || museum.museum_type&.include?('庭園')
        when 'fun'
          score += 5 if museum.museum_type&.include?('科学館') || museum.museum_type&.include?('動物園')
        when 'photo'
          score += 5 if museum.museum_type&.include?('美術館')
        end
      end

      # Q5: 好きな時代
      if answers[:q5].present?
        case answers[:q5]
        when 'ancient'
          score += 5 if museum.name&.include?('古代') || museum.name&.include?('考古')
        when 'medieval'
          score += 5 if museum.name&.include?('中世') || museum.name&.include?('江戸')
        when 'modern'
          score += 5 if museum.name&.include?('近代') || museum.name&.include?('現代')
        when 'contemporary'
          score += 5 if museum.museum_type&.include?('現代美術') || museum.name&.include?('現代')
        when 'all'
          score += 3
        end
      end

      # Q6: 好きな展示物
      if answers[:q6].present?
        case answers[:q6]
        when 'paintings'
          score += 8 if museum.museum_type&.include?('美術館')
        when 'sculptures'
          score += 8 if museum.museum_type&.include?('美術館') || museum.museum_type&.include?('彫刻')
        when 'artifacts'
          score += 8 if museum.museum_type&.include?('博物館') || museum.museum_type&.include?('歴史')
        when 'science'
          score += 8 if museum.museum_type&.include?('科学館') || museum.museum_type&.include?('科学')
        when 'nature'
          score += 8 if museum.museum_type&.include?('自然史') || museum.museum_type&.include?('動物園')
        end
      end

      # Q7: 滞在時間
      if answers[:q7].present?
        case answers[:q7]
        when 'short'
          score += 3 if museum.registration_type&.include?('私立')
        when 'medium'
          score += 5
        when 'long'
          score += 7 if museum.registration_type&.include?('国立')
        when 'all_day'
          score += 7 if museum.registration_type&.include?('国立')
        end
      end

      # Q8: 誰と行く？
      if answers[:q8].present?
        case answers[:q8]
        when 'alone'
          score += 5 if museum.museum_type&.include?('美術館')
        when 'partner'
          score += 5 if museum.museum_type&.include?('美術館') || museum.museum_type&.include?('庭園')
        when 'family'
          score += 5 if museum.museum_type&.include?('科学館') || museum.museum_type&.include?('動物園')
        when 'friends'
          score += 5
        end
      end

      # Q9: 建物の雰囲気
      if answers[:q9].present?
        case answers[:q9]
        when 'historic'
          score += 5 if museum.name&.include?('記念館') || museum.registration_type&.include?('国立')
        when 'modern'
          score += 5 if museum.name&.include?('現代') || museum.name&.include?('21世紀')
        when 'traditional'
          score += 5 if museum.name&.include?('伝統') || museum.name&.include?('民俗')
        when 'any'
          score += 3
        end
      end

      # Q10: 博物館に行く頻度
      if answers[:q10].present?
        case answers[:q10]
        when 'first'
          # 初めての人には有名な博物館
          score += 10 if museum.is_featured
        when 'sometimes'
          score += 5
        when 'often'
          # よく行く人にはマニアックな博物館
          score += 5 unless museum.is_featured
        when 'expert'
          # 玄人にはマニアックな博物館
          score += 8 unless museum.is_featured
        end
      end

      # スコアと博物館を保存
      scored_museums << { museum: museum, score: score }
    end

    # スコアが高い順に上位3件を返す
    top_museums = scored_museums.sort_by { |sm| -sm[:score] }.first(3)
    
    # マッチ度（パーセンテージ）を計算
    max_score = top_museums.first[:score].to_f
    
    @results = top_museums.map do |sm|
      {
        museum: sm[:museum],
        score: sm[:score],
        match_percentage: max_score > 0 ? ((sm[:score] / max_score) * 100).round : 0
      }
    end

    @results.map { |r| r[:museum] }
  end
end