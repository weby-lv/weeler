require "spec_helper"

describe I18n::Backend::Weeler::UsageLogger do
  before(:each) do
    Settings.log_key_usage = 'true'
    @backend_cache = I18n.backend.backends[0].i18n_cache
  end

  describe "1. #log_key_usage" do

    it "logs key to cache store" do
      I18n.t('random.key.count')
      expect(@backend_cache.read([:usage_stats, [I18n.locale, 'random.key.count']])).to eq(1)
      I18n.t('random.key.count')
      expect(@backend_cache.read([:usage_stats, [I18n.locale, 'random.key.count']])).to eq(2)
      I18n.t('random.key.count')
      expect(@backend_cache.read([:usage_stats, [I18n.locale, 'random.key.count']])).to eq(3)
    end

  end

  describe "2. #dump_key_usage" do

    it "dumps stats to database" do
      I18n.t('random.key_dump')
      I18n.t('random.key_dump')
      I18n.t('random.key_dump')
      Settings.log_key_usage = 'dump'
      I18n.t('random.key_dump')
      expect(I18n::Backend::Weeler::TranslationStat.find_by(key: 'random.key_dump').try(:usage_count)).to eq(3)
    end
  end

end
