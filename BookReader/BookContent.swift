//
//  BookContent.swift
//  BookReader
//
//  Created by 최재훈 on 4/12/25.
//

import Foundation
import SwiftUI

struct BookData {
    // ContentView에 있던 긴 텍스트 내용을 이곳으로 옮깁니다.
    static let bookText1 = """
        国境の長いトンネルを抜けると雪国であった。
        夜の底が白くなった。
        信号所に汽車が止まった。
        
        向側の座席から娘が立って来て、島村の前のガラス窓を落した。
        雪の冷気が流れ込んだ。
        娘は窓いっぱいに乗り出して、遠くへ呼ぶように、
        「駅長さあん、駅長さあん。」
        
        明りをさげてゆっくり雪を踏んで来た男は、襟巻で鼻の上まで包み、耳に帽子の毛皮を垂れていた。
        もう古い汽車なので、網棚といっても、繩の網がかけてあるばかりだつたけれど、そのためかえつて飾り紐のようにも見えて、旅情を誘うものがあった。
        島村はそこで自分の外套と襟巻を取つて来て、娘がその上に腰かけるやうにしてやつた。娘の動きにつれて、何か甘い匂いがした。それは化粧品の匂いではなくて、娘のからだの匂いとでも言つたらよいのか、とにかく男心を誘惑するやうな匂いであった。
        汽車が動き出すと、娘は窓枠に片肱をついて、何とはなしに外を眺めてゐる横顔が、夕闇に浮び上つた。それは旅の愁いを帯びてゐるかのやうに見えた。その顔が綺麗だつたので、島村はふと自分の顔を鏡に映してみた。
        
        鏡の中には夕景色が流れていた。つまり、汽車の中の島村の顔に重なって、外の景色が映るのだ。景色は遠近法の深い闇の向うに動いていた。島村の顔のあたりに重なって見えるものは、向う側の座席にいる娘の姿だけだった。娘の姿は淡い光の中に浮かんでいた。汽車の中と外との鏡の映像が交錯して、娘の顔も風景の一部になった。そこには現実の娘がいるのではなく、島村の胸の中を通り過ぎる幻影のような娘がいた。
        
        その時、ふと山の上に燈火が一つぽつんと見えた。それが鏡の中の娘の瞳と重なった。島村ははっとした。なんという美しさだろう。燈火は遠い山の斜面にまたたいていた。娘の瞳の奥で、冷たい光が静かに燃えていた。島村はその光景に心を奪われ、しばし息をのんだ。娘はまだ外の景色を眺めていたが、その瞳の奥に映る小さな燈火は、まるで彼女自身の内なる光のように感じられた。
        
        汽車はなおも走りつづけ、闇は深まり、雪はますます白く輝きはじめた。車内の暖かさと外の冷気との境にあるガラス窓には、いつしか水蒸気が白く曇りついていた。娘は時折、指でその曇りを拭っては、またじっと外を見つめるのだった。島村もまた、その娘の姿と、鏡の中の幻影と、遠い燈火と、深まる雪国の夜とを、静かに見守っていた。すべてが混然一体となり、非現実的な美しさで彼を包み込んでいた。
        
        島村はもう一度娘の顔に目をやった。冷たいほど澄んだ大きな瞳で、どこか寂しげであったが、不思議なほど強く惹きつけられるものがあった。長い睫毛が震えるたびに、車窓の雪明りが反射してきらめいた。彼女の名は葉子というのだろうか、と島村は思った。以前この土地に来た時に、ちらりと見かけた娘かもしれない。だが確信はなかった。
        
            不意に、通路の向こうから別の女の声がした。陽気で、少し調子外れな、しかし活気のある声だった。
            「あら、島村さんじゃありませんか。」
            振り返ると、そこに立っていたのは駒子だった。この温泉町で島村が馴染みにしている芸者である。赤い頬をして、息を弾ませながら彼女は言った。
            「まあ、いついらしったの。連絡くだされば駅まで迎えに行きましたのに。」
        
            駒子は大きな風呂敷包みを抱えていた。何か届け物でもしてきた帰りなのだろう。彼女の快活さが、汽車の重苦しい雰囲気をいくらか和らげるかのようだった。葉子と呼ばれた娘は、駒子が現れると、すっと表情を硬くして窓の外へ視線を戻した。二人の間には何か複雑な感情が流れているのかもしれない、と島村は感じた。
        
            駒子は島村の隣に遠慮なく腰を下ろすと、風呂敷包みを膝の上に置き、堰を切ったように喋り始めた。町の噂、最近あった出来事、他の芸者の話。島村は適当に相槌を打ちながら、時折、窓の外を見つめる葉子の横顔を盗み見た。駒子の現実的な賑やかさと、葉子の夢幻的な静けさとが、奇妙な対比をなして島村の心に刻まれていく。雪国の夜は、こうして人間たちの様々な思いを乗せて、深く、静かに更けていくのだった。
        
            駒子はなおも止まらなかった。彼女の言葉は雪解け水のように溢れ出し、時には楽しげに、時には少し感傷的に、町の情景や人間模様を生き生きと描き出した。芸者としての日常、客とのやり取り、そして彼女自身の孤独感のようなものも、その饒舌さの中に時折垣間見えた。島村は、彼女の飾り気のない率直さに好感を持つ一方で、その底にあるかもしれない純粋さや切なさに思いを馳せた。
        
            ふと、駒子が葉子に声をかけた。「葉子さん、あなたも寒くないの？ 窓、少し閉めたらどう？」葉子は黙って首を横に振るだけで、依然として窓の外の闇を見つめていた。その横顔は能面のように無表情に見える瞬間があった。駒子は少し困ったような顔をしたが、すぐにまた島村に向き直り、別の話題に移った。
        
            島村は、この二人の女性の間に流れる、目に見えない複雑な関係性を感じずにはいられなかった。駒子の生命力溢れる現実感と、葉子のどこか現実離れした透明感。そして自分自身もまた、この雪国の非日常的な空間の中で、現実と幻影の狭間を漂っているような気分だった。彼は東京での日常や仕事を忘れ、ただこの瞬間の感覚に身を委ねていた。
        
            汽車はようやく次の駅に近づき、速度を落とし始めた。窓の外の景色も少しずつ変化し、人家の明かりが増えてくる。葉子は不意に立ち上がり、網棚から自分の荷物を降ろし始めた。小柄な体で懸命に手を伸ばす姿が痛々しい。駒子が手伝おうとしたが、葉子はそれを断るかのように、素早く自分で荷物を下ろした。そして、島村にも駒子にも一瞥もくれず、汽車のデッキの方へと静かに歩いて行った。その姿はまるで、雪の中に溶けていくかのように儚げだった。
        
            駒子はその様子を黙って見送っていたが、やがてため息ともつかぬ息をもらし、「あの子も、いろいろあるのよ」と島村にだけ聞こえるような声で呟いた。その言葉には、同情とも諦めともつかない響きがあった。まもなく汽車は駅のホームに滑り込んだ。ホームには駅長の姿が見えたが、葉子の姿はもうどこにも見当たらなかった。雪は音もなく降り続いていた。
        """
    static let bookText2 = """
        소년은 개울가에서 소녀를 보자 곧 윤 초시네 증손녀(曾孫女)딸이라는 걸 알 수 있었다. 소녀는 개울에다 손을 잠그고 물장난을 하고 있는 것이다. 서울서는 이런 개울물을 보지 못하기나 한 듯 이.
        벌써 며칠째 소녀는, 학교에서 돌아오는 길에 물장난이었다. 그런데, 어제까지 개울 기슭에서 하 더니, 오늘은 징검다리 한가운데 앉아서 하고 있다. 소년은 개울둑에 앉아 버렸다. 소녀가 비키기를 기다리자는 것이다. 요행 지나가는 사람이 있어, 소녀가 길을 비켜 주었다.
        다음 날은 좀 늦게 개울가로 나왔다.
        이 날은 소녀가 징검다리 한가운데 앉아 세수를 하고 있었다. 분홍 스웨터 소매를 걷어올린 목덜미가 마냥 희었다.
        한참 세수를 하고 나더니, 이번에는 물 속을 빤히 들여다 본다. 얼굴이라도 비추어 보는 것이리 라. 갑자기 물을 움켜 낸다. 고기 새끼라도 지나가는 듯. 소녀는 소년이 개울둑에 앉아 있는 걸 아는지 모르는지 그냥 날쌔게 물만 움켜 낸다. 그러나, 번번이 허탕이다. 그대로 재미있는 양, 자꾸 물만 움킨다. 어제처럼 개울을 건너는 사람이 있어야 길 을 비킬 모양이다.
        그러다가 소녀가 물 속에서 무엇을 하나 집어낸다. 하얀 조약돌이었다. 그리고는 벌떡 일어나 팔짝팔짝 징검다리를 뛰어 건너간다.
        다 건너가더니만 홱 이리로 돌아서며, "이 바보."
        조약돌이 날아왔다. 소년은 저도 모르게 벌떡 일어섰다.
        단발 머리를 나풀거리며 소녀가 막 달린다. 갈밭 사잇길로 들어섰다. 뒤에는 청량한 가을 햇살 아래 빛나는 갈꽃뿐.
        이제 저쯤 갈밭머리로 소녀가 나타나리라. 꽤 오랜 시간이 지났다고 생각됐다. 그런데도 소녀는 나타나지 않는다. 발돋움을 했다. 그러고도 상당한 시간이 지났다고 생각됐다.
        저 쪽 갈밭머리에 갈꽃이 한 옴큼 움직였다. 소녀가 갈꽃을 안고 있었다. 그리고, 이제는 천천한 걸음이었다. 유난히 맑은 가을 햇살이 소녀의 갈꽃머리에서 반짝거렸다. 소녀 아닌 갈꽃이 들길을 걸어가는
        것만 같았다.
        소년은 이 갈꽃이 아주 뵈지 않게 되기까지 그대로 서 있었다. 문득, 소녀가 던지 조약돌을 내려 다보았다. 물기가 걷혀 있었다. 소년은 조약돌을 집어 주머니에 넣었다.
        다음 날부터 좀더 늦게 개울가로 나왔다. 소녀의 그림자가 뵈지 않았다. 다행이었다. 그러나, 이상한 일이었다. 소녀의 그림자가 뵈지 않는 날이 계속될수록 소년의 가슴 한 구석에는 어딘
        가 허전함이 자리 잡는 것이었다. 주머니 속 조약돌을 주무르는 버릇이 생겼다.
        그러한 어떤 날, 소년은 전에 소녀가 앉아 물장난을 하던 징검다리 한가운데에 앉아 보았다. 물 속에 손을 잠갔다. 세수를 하였다. 물 속을 들여다보았다. 검게 탄 얼굴이 그대로 비치었다. 싫었다.
        소년은 두 손으로 물 속의 얼굴을 움키었다. 몇 번이고 움키었다. 그러다가 깜짝 놀라 일어나고 말았다. 소녀가 이리로 건너오고 있지 않느냐.'숨어서 내가 하는 일을 엿보고 있었구나.' 소년은 달리기를 시작했다. 디딤돌을 헛디뎠다. 한 발이 물 속에 빠졌다. 더 달렸다.
        몸을 가릴 데가 있어 줬으면 좋겠다. 이 쪽 길에는 갈밭도 없다. 메밀밭이다. 전에 없이 메밀꽃 냄새가 짜릿하게 코를 찌른다고 생각됐다. 미간이 아찔했다. 찝찔한 액체가 입술에 흘러들었다. 코 피였다.
        소년은 한 손으로 코피를 훔쳐내면서 그냥 달렸다. 어디선가 '바보, 바보' 하는 소리가 자꾸만 뒤따라 오는 것 같았다.
        토요일이었다.
        개울가에 이르니, 며칠째 보이지 않던 소녀가 건너편 가에 앉아 물장난을 하고 있었다. 모르는 체 징검다리를 건너기 시작했다. 얼마 전에 소녀 앞에서 한 번 실수를 했을 뿐, 여태 큰길 가듯이 건너던 징검
        다리를 오늘은 조심스럽게 건넌다.
        "얘."
        못 들은 체했다. 둑 위로 올라섰다.
        "얘, 이게 무슨 조개지?"
        자기도 모르게 돌아섰다. 소녀의 맑고 검은 눈과 마주쳤다. 얼른 소녀의 손바닥으로 눈을 떨구었다.
        "비단조개."
        "이름도 참 곱다."
        갈림길에 왔다. 여기서 소녀는 아래편으로 한 삼 마장쯤, 소년은 우대로 한 십 리 가까운 길을 가야 한다.
        소녀가 걸음을 멈추며, "너, 저 산 너머에 가 본 일 있니?"
        벌 끝을 가리켰다.
        "없다."
        "우리, 가보지 않으련? 시골 오니까 혼자서 심심해 못 견디겠다." "저래 봬도 멀다."
        "멀면 얼마나 멀기에? 서울 있을 땐 사뭇 먼 데까지 소풍 갔었다." 소녀의 눈이 금새 '바보,바보,'할 것 만 같았다.
        논 사잇길로 들어섰다. 벼 가을걷이하는 곁을 지났다.
        허수아비가 서 있었다. 소년이 새끼줄을 흔들었다. 참새가 몇 마리 날아간다. '참, 오늘은 일찍 집으로 돌아가 텃논의 참새를 봐야 할걸.' 하는 생각이 든다.
        "야, 재밌다!"
        소녀가 허수아비 줄을 잡더니 흔들어 댄다. 허수아비가 자꾸 우쭐거리며 춤을 춘다. 소녀의 왼쪽 볼에 살포시 보조개가 패었다.
        저만큼 허수아비가 또 서 있다. 소녀가 그리로 달려간다. 그 뒤를 소년도 달렸다. 오늘 같은 날 은 일찍 집으로 돌아가 집안일을 도와야 한다는 생각을 잊어버리기라도 하려는 듯이.
        소녀의 곁을 스쳐 그냥 달린다. 메뚜기가 따끔따끔 얼굴에 와 부딪친다. 쪽빛으로 한껏 갠 가을 하늘이 소년의 눈앞에서 맴을 돈다. 어지럽다. 저놈의 독수리, 저놈의 독수리, 저놈의 독수리가 맴 을 돌고 있기
        때문이다.
        돌아다보니, 소녀는 지금 자기가 지나쳐 온 허수아비를 흔들고 있다. 좀 전 허수아비보다 더 우쭐거린다.
        논이 끝난 곳에 도랑이 하나 있었다. 소녀가 먼저 뛰어 건넜다.
        거기서부터 산 밑까지는 밭이었다.
        수숫단을 세워 놓은 밭머리를 지났다.
        "저게 뭐니?"
        "원두막."
        "여기 참외, 맛있니?"
        "그럼, 참외 맛도 좋지만 수박 맛은 더 좋다."
        "하나 먹어 봤으면."
        소년이 참외 그루에 심은 무우밭으로 들어가, 무우 두 밑을 뽑아 왔다. 아직 밑이 덜 들어 있었다. 잎을 비틀어 팽개친 후, 소녀에게 한 개 건넨다. 그리고는 이렇게 먹어야 한다는 듯이, 먼저 대강이를 한
        입 베물어 낸 다음, 손톱으로 한 돌이 껍질을 벗겨 우쩍 깨문다.
        소녀도 따라 했다. 그러나, 세 입도 못 먹고, "아, 맵고 지려."
        하며 집어던지고 만다.
        "참, 맛없어 못 먹겠다."
        소년이 더 멀리 팽개쳐 버렸다.
        산이 가까워졌다.
        단풍이 눈에 따가웠다.
        "야아!"
        소녀가 산을 향해 달려갔다. 이번은 소년이 뒤따라 달리지 않았다. 그러고도 곧 소녀보다 더 많은 꽃을 꺾었다.
        "이게 들국화, 이게 싸리꽃, 이게 도라지꽃,……."
        "도라지꽃이 이렇게 예쁜 줄은 몰랐네. 난 보랏빛이 좋아! …… 그런데, 이 양산 같이 생긴 노란 꽃이 뭐지?"
        "마타리꽃."
        소녀는 마타리꽃을 양산 받듯이 해 보인다. 약간 상기된 얼굴에 살포시 보조개를 떠올리며.다시 소년은 꽃 한 옴큼을 꺾어 왔다. 싱싱한 꽃가지만 골라 소녀에게 건넨다.
        그러나 소녀는
        "하나도 버리지 마라."
        산마루께로 올라갔다.
        맞은편 골짜기에 오순도순 초가집이 몇 모여 있었다.
        누가 말할 것도 아닌데, 바위에 나란히 걸터앉았다. 유달리 주위가 조용해진 것 같았다. 따가운 가을 햇살만이 말라가는 풀 냄새를 퍼뜨리고 있었다.
        "저건 또 무슨 꽃이지?"
        적잖이 비탈진 곳에 칡덩굴이 엉키어 꽃을 달고 있었다.
        "꼭 등꽃 같네. 서울 우리 학교에 큰 등나무가 있었단다. 저 꽃 을 보니까 등나무 밑에서 놀 던 동무들 생각이 난다."
        소녀가 조용히 일어나 비탈진 곳으로 간다. 꽃송이가 많이 달린 줄기를 잡고 끊기 시작한다. 좀처럼 끊어지지 않는다. 안간힘을 쓰다가 그만 미끄러지고 만다. 칡덩굴을 그러쥐었다.
        소년이 놀라 달려갔다. 소녀가 손을 내밀었다. 손을 잡아 이끌어 올리며, 소년은 제가 꺾어다 줄 것을 잘못했다고 뉘우친다. 소녀의 오른쪽 무릎에 핏방울이 내맺혔다. 소년은 저도 모르게 생채기 에 입술을
        가져다 대고 빨기 시작했다. 그러다가, 무슨 생각을 했는지 홱 일어나 저 쪽으로 달려간 다.
        좀 만에 숨이 차 돌아온 소년은
        "이걸 바르면 낫는다."
        송진을 생채기에다 문질러 바르고는 그 달음으로 칡덩굴 있는 데로 내려가, 꽃 많이 달린 몇 줄기를 이빨로 끊어 가지고 올라온다. 그리고는, "저기 송아지가 있다. 그리 가 보자."
        누렁송아지였다. 아직 코뚜레도 꿰지 않았다.
        소년이 고삐를 바투 잡아 쥐고 등을 긁어 주는 체 훌쩍 올라탔다. 송아지가 껑충거리며 돌아간 다.
        소녀의 흰 얼굴이, 분홍 스웨터가, 남색 스커트가, 안고 있는 꽃과 함께 범벅이 된다. 모두가 하 나의 큰 꽃묶음 같다. 어지럽다. 그러나, 내리지 않으리라. 자랑스러웠다. 이것만은 소녀가 흉내 내지 못할, 자
        기 혼자만이 할 수 있는 일인 것이다.
        "너희, 예서 뭣들 하느냐?"
        농부(農夫)하나가 억새풀 사이로 올라왔다.
        송아지 등에서 뛰어내렸다. 어린 송아지를 타서 허리가 상하면 어쩌느냐고 꾸지람을 들을 것만 같다.
        그런데, 나룻이 긴 농부는 소녀 편을 한 번 훑어보고는 그저 송아지 고삐를 풀어 내면서, "어서들 집으로 가거라. 소나기가 올라."
        참, 먹장구름 한 장이 머리 위에 와 있다. 갑자기 사면이 소란스러워진 것 같다. 바람이 우수수 소리를 내며 지나간다. 삽시간에 주위가 보랏빛으로 변했다.
        산을 내려오는데, 떡갈나무 잎에서 빗방울 듣는 소리가 난다. 굵은 빗방울이었다. 목덜미가 선뜻 선뜻했다. 그러자, 대번에 눈앞을 가로막는 빗줄기.
        비안개 속에 원두막이 보였다. 그리로 가 비를 그을 수밖에.
        그러나, 원두막은 기둥이 기울고 지붕도 갈래갈래 찢어져 있었다. 그런 대로 비가 덜 새는 곳을 가려 소녀를 들어서게 했다.
        소녀의 입술이 파아랗게 질렸다. 어깨를 자꾸 떨었다.
        무명 겹저고리를 벗어 소녀의 어깨를 싸 주었다. 소녀는 비에 젖은 눈을 들어 한 번 쳐다보았을 뿐, 소년이 하는 대로 잠자코 있었다. 그리고는, 안고 온 꽃묶음 속에서 가지가 꺾이고 꽃이 일그러진 송이를
        골라 발 밑에 버린다. 소녀가 들어선 곳도 비가 새기 시작했다. 더 거기서 비를 그을 수 없었다.
        밖을 내다보던 소년이 무엇을 생각했는지 수수밭 쪽으로 달려간다. 세워 놓은 수숫단 속을 비집어 보더니, 옆의 수숫단을 날라다 덧세운다. 다시 속을 비집어 본다. 그리고는 이쪽을 향해 손짓을 한다.
        수숫단 속은 비는 안 새었다. 그저 어둡고 좁은 게 안 됐다. 앞에 나앉은 소년은 그냥 비를 맞아 야만 했다. 그런 소년의 어깨에서 김이 올랐다.
        소녀가 속삭이듯이, 이리 들어와 앉으라고 했다. 괜찮다고 했다. 소녀가 다시, 들어와 앉으라고 했다.
        할 수 없이 뒷걸음질을 쳤다. 그 바람에, 소녀가 안고 있는 꽃묶음이 망그러졌다. 그러나, 소녀는 상관없다고 생각했다. 비에 젖은 소년의 몸 내음새가 확 코에 끼얹혀졌다. 그러나, 고개를 돌리지 않았다. 도리
        어 소년의 몸기운으로 해서 떨리던 몸이 적이 누그러지는 느낌이었다.
        소란하던 수숫잎 소리가 뚝 그쳤다. 밖이 멀개졌다.
        수숫단 속을 벗어 나왔다. 멀지 않은 앞쪽에 햇빛이 눈부시게 내리붓고 있었다. 도랑 있는 곳까지와 보니, 엄청나게 물이 불어 있었다. 빛마저 제법 붉은 흙탕물이었다. 뛰어 건널 수가 없었다.
        소년이 등을 돌려 댔다. 소녀가 순순히 업히었다. 걷어올린 소년의 잠방이까지 물이 올라왔다.
        소녀는 '어머나'소리를 지르며 소년의 목을 끌어안았다.
        개울가에 다다르기 전에, 가을 하늘이 언제 그랬는가 싶게 구름 한 점 없이 쪽빛으로 개어 있었다.
    """
    static let bookText3 = """
        He was an old man who fished alone in a skiff in the Gulf Stream and he had gone eighty-four days now without taking a fish. In the first forty days a boy had been with him. But after forty days without a fish the boy's parents had told him that the old man was now definitely and finally salao, which is the worst form of unlucky, and the boy had gone at their orders in another boat which caught three good fish the first week. It made the boy sad to see the old man come in each day with his skiff empty and he always went down to help him carry either the coiled lines or the gaff and harpoon and the sail that was furled around the mast. The sail was patched with flour sacks and, furled, it looked like the flag of permanent defeat.
        The old man was thin and gaunt with deep wrinkles in the back of his neck. The brown blotches of the benevolent skin cancer the sun brings from its
        reflection on the tropic sea were on his cheeks. The blotches ran well down the sides of his face and his hands had the deep-creased scars from handling heavy fish on the cords. But none of these scars were fresh. They were as old as erosions in a fishless desert.
        Everything about him was old except his eyes and they were the same color as the sea and were cheerful and undefeated.
        "Santiago," the boy said to him as they climbed the bank from where the skiff was hauled up. "I could go with you again. We've made some money.
        The old man had taught the boy to fish and the boy loved him.
        "No," the old man said. "You're with a lucky boat. Stay with them."
        "Rut remember how you went eighty-seven days without fish and then we caught big ones every day for three weeks."
        "I remember," the old man said. "I know you did not leave me because you doubted."
        "It was papa made me leave. I am a boy and I must obey him."
        "I know," the old man said. "It is quite normal."
        "He hasn't much faith."
        "No," the old man said. "But we have. Haven't we?"
        'Yes," the boy said. "Can I offer you a beer on the Terrace and then we'll take the stuff home."
        "Why not?" the old man said. "Between fishermen." They sat on the Terrace and many of the fishermen made fun of the old man and he was not angry. Others, of the older fishermen, looked at him and were sad. But they did not show it and they spoke politely about the current and the depths they had drifted their lines at and the steady good weather and of what they had seen. The successful fishermen of that day were already in and had butchered their marlin out and carried them laid full length across two planks, with two men staggering at the end of each plank, to the fish house where they waited for the ice truck to carry them to the market in Havana. Those who had caught sharks had taken them to the shark factory on the other side of the cove where they were hoisted on a block and tackle, their livers removed, their fins cut off and their hides skinned out and their flesh cut into strips for salting.
        When the wind was in the east a smell came across the harbour from the shark factory; but today there
        was only the faint edge of the odour because the wind had backed into the north and then dropped off and it was pleasant and sunny on the Terrace.
        "Santiago," the boy said.
        "Yes," the old man said. He was holding his glass and thinking of many years ago.
        "Can I go out to get sardines for you for tomorrow?"
        "No. Go and play baseball. I can still row and Rogelio will throw the net."
        "I would like to go. If I cannot fish with you. I would like to serve in some way."
        "You bought me a beer," the old man said. "You are already a man."
        "How old was I when you first took me in a boat?"
        "Five and you nearly were killed when I brought the fish in too green and he nearly tore the boat to pieces. Can you remember?"
        "I can remember the tail slapping and banging and the thwart breaking and the noise of the clubbing. I can remember you throwing me into the bow where the wet coiled lines were and feeling the whole boat shiver and the noise of you clubbing him like chopping a tree down and the sweet blood smell all over me."
        "Can you really remember that or did I just tell it to you?"
        "I remember everything from when we first went together."
        The old man looked at him with his sun-burned, confident loving eyes.
        "If you were my boy I'd take you out and gamble," he said. "But you are your father's and your mother's and you are in a lucky boat."
        "May I get the sardines? I know where I can get four baits too."
        "I have mine left from today. I put them in salt in the box."
        "Let me get four fresh ones."
        "One," the old man said. His hope and his confidence had never gone. But now they were freshening as when the breeze rises.
        "Two," the boy said.
        "Two," the old man agreed. "You didn't steal them?"
        "I would," the boy said. "But I bought these."
        "Thank you," the old man said. He was too simple to wonder when he had attained humility. But he
        knew he had attained it and he knew it was not disgraceful and it carried no loss of true pride.
        'Tomorrow is going to be a good day with this current," he said.
        "Where are you going?" the boy asked.
        "Far out to come in when the wind shifts. I want to be out before it is light."
        "I'll try to get him to work far out," the boy said. "Then if you hook something truly big we can come to your aid."
        "He does not like to work too far out."
        "No," the boy said. "Rut I will see something that he cannot see such as a bird working and get him to come out after dolphin."
        "Are his eyes that bad?"
        "He is almost blind."
        "It is strange," the old man said. "He never went turtle-ing. That is what kills the eyes."
        "But you went turtle-ing for years off the Mosquito Coast and your eyes are good."
        "I am a strange old main"
        "Rut are you strong enough now for a truly big fish?"
        "I think so. And there are many tricks."
        "Let us take the stuff home," the boy said. "So I can get the cast net and go after the sardines."
        They picked up the gear from the boat. The old man carried the mast on his shoulder and the boy carried the wooden bo,4 with the coiled, hard-braided brown lines, the gaff and the harpoon with its shaft. The box with the baits was under the stern of the skiff along with the club that was used to subdue the big fish when they were brought alongside. No one would steal from the old man but it was better to take the sail and the heavy lines home as the dew was bad for them and, though he was quite sure no local people would steal from him, the old man thought that a gaff and a harpoon were needless temptations to leave in a boat.
        They walked up the road together to the old man's shack and went in through its open door. The old man leaned the mast with its wrapped sail against the wall and the boy put the box and the other gear beside it. The mast was nearly as long as the one room of the shack. The shack was made of the tough budshields of the royal palm which are called guano and in it there was a bed, a table, one chair, and a place on the dirt floor to cook with charcoal. On the brown walls of the flattened, overlapping leaves of the sturdy fibered
        guano there was a picture in color of the Sacred Heart of Jesus and another of the Virgin of Cobre. These were relics of his wife. Once there had been a tinted photograph of his wife on the wall but he had taken it down because it made him too lonely to see it and it was on the shelf in the corner under his clean shirt.
    """
}
