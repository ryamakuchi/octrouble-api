describe Sample, type: :model do
  describe '#issues' do
    before do
    end

    context 'GitHub URL で入力された場合' do
      it '該当リポジトリの Issues を返す'
    end

    context 'user/repo で入力された場合' do
      it '該当リポジトリの Issues を返す'
    end

    context 'user/repo や GitHub URL 以外の文字列が入力された場合' do
      it '正しいリポジトリを指定してください'
    end

    context '該当の Issues が 0件だった場合' do
      it 'Issues は 0件です'
    end

    context '該当の Issues が 0件だった場合' do
      it 'リポジトリが見つかりません'
    end
  end
end
