//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Color_card {

    uint card_id_now;
    address owner; // 平台（我们）

    // type of Card
    struct Type {
        uint level;
        uint color;
        uint num; // how many in total
    }

    // each Card
    struct Card {
        uint card_id; //每张卡的独立编号
        uint point; // 点数（用来计算等级）
        bool selling; // 是否正在出售
        uint sell_money;
        address owned;
    }

    struct Person {
        string name;
        uint last_buy_day;
        uint buy_count;
        uint[] my_card;
    }

    Type[] all_type;

    mapping (address => Person) people;
    mapping (uint => Card) cards;
    mapping (uint => uint) card_type; // card_id to all_type下标
    mapping (address => uint) lastCheckIn;

    // 正在出售的商品
    uint[] on_selling;

    constructor() {
        card_id_now = 0;
        owner = msg.sender;
        Type memory aa;
        aa.num = 0;
        for (uint i=0; i<50; i++){
            aa.level = i/4 + 1;
            aa.color = i%4;
            all_type.push(aa);
        }
    }

    function rand() public view returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
            block.number
        )));
        return seed % 998244353;
    }

    // 查询稀有度
    function rarity_search(uint level, uint color) public view returns(uint) {
        return all_type[level*4+color-4].num;
    }

    // 查询详细信息
    function show_specific(uint id) public view returns(Card memory){
        return cards[id];// 显示详细信息
    }
    
    // 获取用户名
    function get_username(address addr) public view returns(string memory){
        return people[addr].name;// 获取用户名
    }

    // 显示所有拥有的
    function show_owned() public view returns(Card[] memory, Type[] memory){ // 展示拥有的
        // Card[] memory a = people[msg.sender].my_card;
        Card[] memory a = new Card[](people[msg.sender].my_card.length);
        Type[] memory b = new Type[](people[msg.sender].my_card.length);
        for (uint i=0; i<people[msg.sender].my_card.length; i++) {
            a[i] = cards[people[msg.sender].my_card[i]];
            b[i] = all_type[card_type[a[i].card_id]];
        }
        return (a, b);
    }

    function set_username(string memory namee) public returns(bool){
        if (bytes(namee).length == 0)
            return false;
        people[msg.sender].name = namee;
        return true; // 成功设置用户名，或改名
    }

    // 更新对应的数据
    function if_upgrade(uint id) public {
        uint threshold = all_type[card_type[id]].level;
        threshold = 8 * threshold * (threshold + 1);
        while (cards[id].point >= threshold) {
            cards[id].point -= threshold;
            all_type[card_type[id]].num--;
            card_type[id] = card_type[id] + 4;
            all_type[card_type[id]].num++;
            threshold = all_type[card_type[id]].level;
            threshold = 8 * threshold * (threshold + 1);
        }
        return;   
    }

    // 签到
    function check() public returns(bool){
        (uint y1, uint m1, uint d1) = daysToDate(block.timestamp, 8);
        (uint y2, uint m2, uint d2) = daysToDate(lastCheckIn[msg.sender], 8);
        lastCheckIn[msg.sender] = block.timestamp;
        if (y1 == y2 && m1 == m2 && d1 == d2) {
            return false;
        }
        for (uint i=0; i<people[msg.sender].my_card.length; i++) {
            cards[people[msg.sender].my_card[i]].point += 1;
            if_upgrade(people[msg.sender].my_card[i]);
        }
        return true; 
    }

    // 升级
    function upgrade(uint be_upgrade, uint[] memory material) public returns(Card memory,Type memory) {
        require (cards[be_upgrade].selling == false, "Cannot be selling");
        for (uint i=0; i<material.length; i++) {
            require (cards[material[i]].selling == false, "Cannot be selling");
        }
        for(uint i=0; i<material.length; i++){
            uint level = all_type[card_type[material[i]]].level - 1;
            while (level > 0) {
                cards[be_upgrade].point += 4 * level * (level + 1);
                level--;
                if_upgrade(be_upgrade);
            }
            cards[be_upgrade].point += cards[material[i]].point;
            if_upgrade(be_upgrade);
        }
        // update person card_id
        for (uint i=0; i<material.length; i++){
            for (uint j=0; j<people[msg.sender].my_card.length; j++){
                if (material[i] == people[msg.sender].my_card[j]) {
                    people[msg.sender].my_card[i] = people[msg.sender].my_card[people[msg.sender].my_card.length-1];
                    people[msg.sender].my_card.pop();
                    continue;
                }
            }
        }
        // delete num
        for (uint i=0; i<material.length; i++){
            all_type[card_type[material[i]]].num--;
        }
        return (cards[be_upgrade], all_type[card_type[be_upgrade]]);
    }

    function change_color(uint be_upgrade, uint material) public returns(Card memory,Type memory) {
        if (cards[be_upgrade].selling == true) {
            return (cards[be_upgrade],all_type[card_type[be_upgrade]]);
        }
        if(cards[material].selling == true){
            return (cards[be_upgrade],all_type[card_type[be_upgrade]]);
        }
        uint aa = rand();
        uint bb = (card_type[be_upgrade]/4)+1;
        if (aa%10 == 0) {
            all_type[card_type[be_upgrade]].num--;
            card_type[be_upgrade] = (bb-1)*4;            
            all_type[card_type[be_upgrade]].num++;
        }
        else if (aa%10 == 1 || aa%10==2){
            all_type[card_type[be_upgrade]].num--;
            card_type[be_upgrade] = (bb-1)*4+1;            
            all_type[card_type[be_upgrade]].num++;
        }
        else if (aa%10 == 3 || aa%10==4 || aa%10==5){
            all_type[card_type[be_upgrade]].num--;
            card_type[be_upgrade] = (bb-1)*4+2;            
            all_type[card_type[be_upgrade]].num++;
        }
        else if (aa%10 == 6 || aa%10==7 || aa%10==8 || aa%10==9){
            all_type[card_type[be_upgrade]].num--;
            card_type[be_upgrade] = (bb-1)*4+3;            
            all_type[card_type[be_upgrade]].num++;
        }
        all_type[card_type[material]].num--;
        for (uint i=0; i<people[msg.sender].my_card.length; i++){
            if (people[msg.sender].my_card[i] == material) {
                people[msg.sender].my_card[i] = people[msg.sender].my_card[people[msg.sender].my_card.length-1];
                people[msg.sender].my_card.pop();
                return (cards[be_upgrade],all_type[card_type[be_upgrade]]);
            }
        }
        return (cards[be_upgrade],all_type[card_type[be_upgrade]]);
        //Card new; // material为材料，be_upgrade是要升级的卡牌，返回值为新卡牌
    }

    uint constant internal SECONDS_PER_DAY = 24 * 60 * 60;
    uint constant internal SECONDS_PER_HOUR = 60 * 60;
    uint constant internal SECONDS_PER_MINUTE = 60;
    uint constant internal OFFSET19700101 = 2440588;
 
    //每月天数
    uint8[] monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    function daysToDate(uint timestamp, uint8 timezone) public pure returns (uint year, uint month, uint day){
        return _daysToDate(timestamp + timezone * uint(SECONDS_PER_HOUR));
    }

    //时间戳转日期，UTC时区
    function _daysToDate(uint timestamp) private pure returns (uint year, uint month, uint day) {
        uint _days = uint(timestamp) / SECONDS_PER_DAY;
 
        uint L = _days + 68569 + OFFSET19700101;
        uint N = 4 * L / 146097;
        L = L - (146097 * N + 3) / 4;
        year = 4000 * (L + 1) / 1461001;
        L = L - 1461 * year / 4 + 31;
        month = 80 * L / 2447;
        day = L - 2447 * month / 80;
        L = month / 11;
        month = month + 2 - 12 * L;
        year = 100 * (N - 49) + year + L;
    }

    function get_rand() public view returns(uint) {
        uint aa = rand();
        uint level;
        uint color;
        if (aa%127==0){
            level=7;
        }
        else if (aa%127>=1 && aa%127<=2){
            level=6;
        }
        else if (aa%127>=3 && aa%127<=6){
            level=5;
        }
        else if (aa%127>=7 && aa%127<=14){
            level=4;
        }
        else if (aa%127>=15 && aa%127<=30){
            level=3;
        }
        else if (aa%127>=31 && aa%127<=62){
            level=2;
        }
        else if (aa%127>=63 && aa%127<=126){
            level=1;
        }
        uint bb = rand();
        if (bb%4==0){
            color=0;
        }
        else if (bb%4==1){
            color=1;
        }
        else if (bb%4==2){
            color=2;
        }
        else if (bb%4==3){
            color=3;
        }
        return (level-1)*4+color;
    }

    function purchaseChance() public view returns(uint) {
        (uint y1, uint m1, uint d1) = daysToDate(block.timestamp, 8);
        (uint y2, uint m2, uint d2) = daysToDate(people[msg.sender].last_buy_day, 8);
        if (y1 == y2 && m1 == m2 && d1 == d2) {
            if(people[msg.sender].buy_count==1)
                return 1;
            else
                return 0;
        }
        else
            return 2;
    }

    function lastPurchased() public view returns(Card memory, Type memory) {
        Card memory c = cards[people[msg.sender].my_card[people[msg.sender].my_card.length - 1]];
        return (c, all_type[card_type[c.card_id]]);
    }

    // 开箱
    function purchase() public returns(bool,Card memory,Type memory){ // 购买
        (uint y1, uint m1, uint d1) = daysToDate(block.timestamp, 8);
        (uint y2, uint m2, uint d2) = daysToDate(people[msg.sender].last_buy_day, 8);
        if (y1 == y2 && m1==m2 && d1==d2){
            if(people[msg.sender].buy_count==1) {
                uint aa = get_rand();
                cards[card_id_now].card_id = card_id_now;
                cards[card_id_now].point = 0;
                cards[card_id_now].selling = false;
                cards[card_id_now].sell_money = 0;
                cards[card_id_now].owned = msg.sender;
                people[msg.sender].my_card.push(card_id_now);
                card_type[card_id_now] = aa;
                all_type[aa].num = all_type[aa].num+1;
                card_id_now++;
                people[msg.sender].buy_count = 0;
                return (true, cards[card_id_now-1], all_type[aa]);
            }
            else {
                return (false, 
                        Card({
                            card_id:0,
                            point:0, 
                            selling:false, 
                            sell_money:0, 
                            owned:msg.sender}), 
                        Type({
                            level:0,
                            color:0,
                            num:0}));
            }
        }
        else {
            people[msg.sender].last_buy_day = block.timestamp;
            uint aa = get_rand();
            cards[card_id_now].card_id = card_id_now;
            cards[card_id_now].point = 0;
            cards[card_id_now].selling = false;
            cards[card_id_now].sell_money = 0;
            cards[card_id_now].owned = msg.sender;
            people[msg.sender].my_card.push(card_id_now);
            card_type[card_id_now] = aa;
            all_type[aa].num = all_type[aa].num+1;
            card_id_now++;
            people[msg.sender].buy_count = 1;
            return (true, cards[card_id_now-1], all_type[aa]);
        }
    }

    // 出售
    function sell(uint card_id, uint money) public returns(bool){
        if (cards[card_id].selling)
            return false;
        cards[card_id].selling = true;
        cards[card_id].sell_money = money;
        on_selling.push(card_id);
        return true; // 将我的id为card_id的卡牌出售，价格为money
    }

    // 更改价格
    function change_money(uint card_id, uint money) public returns(bool){
        cards[card_id].selling = true;
        cards[card_id].sell_money = money;
        return true; // 将我的id为card_id的卡牌出售价格改为money
    }

    // 取消出售
    function cancel_sell(uint card_id) public returns(bool){
        cards[card_id].selling = false;
        cards[card_id].sell_money = 0;
        for(uint i=0; i<on_selling.length; i++){
            if (on_selling[i] == card_id){
                on_selling[i] = on_selling[on_selling.length-1];
                on_selling.pop();
                break;
            }
        }
        return true; // 将我的id为card_id的卡牌取消出售
    }

    // 购买
    function buy(uint card_id, uint money, address payable to) public payable returns(bool){
        require (msg.value > money, "need more money!");
        payable(to).transfer(money);
        for (uint i=0; i<people[to].my_card.length; i++){
            if (people[to].my_card[i] == card_id) {
                people[to].my_card[i] = people[to].my_card[people[to].my_card.length-1];
                people[to].my_card.pop();
            }
        }
        people[msg.sender].my_card.push(card_id);
        for(uint i=0; i<on_selling.length; i++){
            if (on_selling[i] == card_id){
                on_selling[i] = on_selling[on_selling.length-1];
                on_selling.pop();
                break;
            }
        }
        cards[card_id].selling = false;
        cards[card_id].sell_money = 0;
        cards[card_id].owned = msg.sender;
        return true; // 购买to的id为card_id的卡牌，向to转账money
    }

    // 展示自己的出售状态
    function show_my_selling() public view returns(Card[] memory, Type[] memory){
        Card[] memory aa = new Card[](people[msg.sender].my_card.length);
        Type[] memory bb = new Type[](people[msg.sender].my_card.length);
        uint c = 0;
        for (uint i=0; i<people[msg.sender].my_card.length; i++){
            if (cards[people[msg.sender].my_card[i]].selling == true){
                aa[c] = cards[people[msg.sender].my_card[i]];
                bb[c] = all_type[card_type[people[msg.sender].my_card[i]]];
                c++;
            }
        }
        Card[] memory cc = new Card[](c);
        Type[] memory dd = new Type[](c);
        for (uint i=0; i<c; i++){
            cc[i] = aa[i];
            dd[i] = bb[i];
        }
        return (cc,dd);
    }

    // 所有在售商品
    function all_selling() public view returns(Card[] memory, Type[] memory){
        Card[] memory aa = new Card[](on_selling.length);
        Type[] memory bb = new Type[](on_selling.length);
        // uint c = 0;
        for (uint i=0; i<on_selling.length; i++){
            aa[i] = cards[on_selling[i]];
            bb[i] = all_type[card_type[on_selling[i]]];
            // c++;
        }
        return (aa,bb);
    }
}

