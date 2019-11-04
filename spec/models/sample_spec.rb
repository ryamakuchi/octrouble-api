# frozen_string_literal: true

describe Sample, type: :model do
  describe '#issues' do
    context 'Issues が取得できる場合' do
      before do
        allow(sample).to receive(:get_issues).and_return(
          '"title 1","body 1","html_url 1"\n"title 2","body 2","html_url 2"\n"title 3","body 3","html_url 3"'
        )
      end

      context 'GitHub URL で入力された場合' do
        subject(:sample) { Sample.new(url: 'https://github.com/rails/rails') }

        it '該当リポジトリの Issues を返す' do
          expect(sample.issues).to eq(
            '"title 1","body 1","html_url 1"\n"title 2","body 2","html_url 2"\n"title 3","body 3","html_url 3"'
          )
        end

        context 'トレイリングスラッシュがついている場合' do
          subject(:sample) { Sample.new(url: 'https://github.com/rails/rails/') }

          it '該当リポジトリの Issues を返す' do
            expect(sample.issues).to eq(
              '"title 1","body 1","html_url 1"\n"title 2","body 2","html_url 2"\n"title 3","body 3","html_url 3"'
            )
          end
        end
      end

      context 'user/repo で入力された場合' do
        subject(:sample) { Sample.new(url: 'rails/rails') }

        it '該当リポジトリの Issues を返す' do
          expect(sample.issues).to eq(
            '"title 1","body 1","html_url 1"\n"title 2","body 2","html_url 2"\n"title 3","body 3","html_url 3"'
          )
        end
      end
    end

    context 'Issues が取得できない場合' do
      context 'user/repo や GitHub URL 以外の文字列が入力された場合' do
        subject(:sample) { Sample.new(url: 'https://rails/rails') }

        it 'GitHub URL もしくは user/repo という形式で検索してください' do
          expect(sample.issues).to eq(nil)
          expect(sample.message).to eq(
            'GitHub URL もしくは user/repo という形式で検索してください'
          )
        end
      end

      context '該当の Issues が 0件だった場合' do
        before do
          allow(sample).to receive(:get_issues).and_return('Issue is not found.')
        end

        subject(:sample) { Sample.new(url: 'ryamakuchi/octrouble') }

        it 'Issues は 0件です' do
          expect(sample.issues).to eq('Issue is not found.')
          expect(sample.message).to eq(
            'ryamakuchi/octrouble の Issues は 0件です'
          )
        end
      end

      context '該当の Issues が見つからなかった場合' do
        before do
          allow(sample).to receive(:get_issues).and_return(
            'Octokit::NotFound\n' \
            'GET https://api.github.com/repos/ryamakuchi/octrouble/issues?page=1: 404 - Not Found ' \
            '// See: https://developer.github.com/v3/issues/#list-issues-for-a-repository\n' \
            "Repository 'ryamakuchi/octrouble' is not found.\n"
          )
        end

        subject(:sample) { Sample.new(url: 'ryamakuchi/octrouble') }

        it 'user/repo リポジトリが見つかりません' do
          expect(sample.issues).to eq(
            'Octokit::NotFound\n' \
            'GET https://api.github.com/repos/ryamakuchi/octrouble/issues?page=1: 404 - Not Found ' \
            '// See: https://developer.github.com/v3/issues/#list-issues-for-a-repository\n' \
            "Repository 'ryamakuchi/octrouble' is not found.\n"
          )
          expect(sample.message).to eq(
            'ryamakuchi/octrouble リポジトリが見つかりません'
          )
        end
      end
    end
  end
end
