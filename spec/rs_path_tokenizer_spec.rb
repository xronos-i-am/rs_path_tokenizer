require 'spec_helper'

describe RsPathTokenizer do
  before :each do
    @tokens_data = {
      'balashiha' => ['r', 'balashiha'],
      'gorodskoj-okrug-balashiha-1' => ['r', 'balashiha-1'],
      'gorodskoj-okrug-balashiha-11' => ['r', 'balashiha-11'],
      'balashiha-gorodskoj-okrug' => ['r', 'balashiha-gorodskoj-okrug'],
      'gorodskoj-okrug-drugoi' => ['r', 'gorodskoj-okrug-drugoi'],
      'expensive' => ['sort', 'expensive'],
    }

    @tokenizer = RsPathTokenizer::Tokenizer.new( @tokens_data )
  end

  it 'shows best results when tokens overlaps' do
    results = {"balashiha" => ["r", "balashiha"], "gorodskoj-okrug-drugoi" => ["r", "gorodskoj-okrug-drugoi"]}

    expect( @tokenizer.tokenize( 'balashiha-gorodskoj-okrug-drugoi' ) ).to eq results
  end

  it 'shows matched result' do
    results = {"gorodskoj-okrug-balashiha-1" => ["r", "balashiha-1"]}
    expect( @tokenizer.tokenize( 'gorodskoj-okrug-balashiha-1' ) ).to eq results

    results = {"gorodskoj-okrug-balashiha-11" => ["r", "balashiha-11"]}
    expect( @tokenizer.tokenize( 'gorodskoj-okrug-balashiha-11' ) ).to eq results
  end

  it 'returns price range' do
    @tokens_data['price-*-*'] = ["price", nil]
    @tokens_data['price-*'] = ["price", nil]

    @tokenizer = RsPathTokenizer::Tokenizer.new( @tokens_data )

    results = {"balashiha"=>["r", "balashiha"], 'price-*-*' => ["price", "0", "100"]}
    expect( @tokenizer.tokenize( 'balashiha-price-0-100' ) ).to eq results

    results = {"balashiha"=>["r", "balashiha"], 'price-*' => ["price", "100"]}
    expect( @tokenizer.tokenize( 'balashiha-price-100' ) ).to eq results

    results = {"balashiha"=>["r", "balashiha"], "price-*-*"=>["price", "0", "100"], "expensive"=>["sort", "expensive"]}
    expect( @tokenizer.tokenize( 'balashiha-price-0-100-expensive' ) ).to eq results

    results = {"balashiha"=>["r", "balashiha"], "price-*"=>["price", "100"], "expensive"=>["sort", "expensive"]}
    expect( @tokenizer.tokenize( 'balashiha-price-100-expensive' ) ).to eq results
  end

  it 'nothing found' do
    expect( @tokenizer.tokenize( 'incorrect-url' ) ).to eq nil
  end

  it 'too long url' do
    expect{ @tokenizer.tokenize( 'a-b' * 501 ) }.to raise_error RsPathTokenizer::Error
  end

  it 'incorrect token' do
    tokens_data = {'*' => ["all", true]}
    expect{ RsPathTokenizer::Tokenizer.new( tokens_data ) }.to raise_error RsPathTokenizer::Error
  end
end
