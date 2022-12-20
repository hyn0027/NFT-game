<template>
    <v-toolbar title="NFT Market" class="fixed-bar">
        <v-btn
            stacked
            variant="text"
            @click="jumpTo('/upgrade')"
        >
            <v-icon icon="mdi-arrow-up-bold-circle-outline"></v-icon>
            upgrade
        </v-btn>
        <v-btn
            stacked
            variant="text"
            @click="jumpTo('/market')"
        >
            <v-icon icon="mdi-shopping"></v-icon>
            market
        </v-btn>
        <v-btn
            stacked
            variant="text"
            @click="jumpTo('/raffle')"
        >
            <v-icon icon="mdi-treasure-chest"></v-icon>
            treasure
        </v-btn>
        <v-btn
            stacked
            variant="text"
            @click="jumpTo('/user')"
        >
            <v-icon icon="mdi-account"></v-icon>
            Homepage
        </v-btn>
    </v-toolbar>
    <v-container class="px-15 py-15">
        <v-row justify="center">
            <v-col
              v-for="(item, index) in cards"
              :key="item.card_id"
              cols="9"
              sm="6"
              md="4"
              lg="3"
            >

                <v-card width="240">
                    <v-toolbar>
                        <v-toolbar-title class="text-h6">
                            Level {{ types[index].level }}
                        </v-toolbar-title>
                        <template v-slot:append>
                            <v-btn color="primary" icon="mdi-cart" @click="buy(item.card_id, types[index].level, types[index].color, item.sell_money, types[index].num, item.owned)"></v-btn>
                        </template>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="Number(item.point) * 100 / (Number(types[index].level) * (Number(types[index].level) + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{Number(item.point)}} / {{ (Number(types[index].level) * (Number(types[index].level) + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-0">
                        <v-img
                            height="265"
                            :src="find_pic(types[index].color, types[index].level)"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-text class="py-4">
                        <div class="font-weight py-0">
                            Price: {{item.sell_money}} ETH, Rarity: {{ types[index].num }}
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
    <v-dialog
        v-model="dialog"
        max-width="400"
        height = "630"
        v-if="this.dialog" 
        persistent
    >
        <v-card width="350" align-center>
            <v-card-title>
                DO YOU WANT TO BUY THIS CARD
            </v-card-title>
            <v-card-text>
                <div style="display: flex">
                    <v-img
                    height="280"
                    width="235"
                    :src="find_pic(this.transanction_card.color, this.transanction_card.level)"
                    cover
                    class="text-white"
                    >
                    </v-img>
                </div>
                <v-card-text style="font-size: 1em;">
                    <div class="font-weight ml-1 mb-3">
                        Level: {{transanction_card.color}}
                    </div>
                    <div class="font-weight ml-1 mb-3">
                        Rarity: {{transanction_card.rarity}}
                    </div>
                    <div class="font-weight ml-1 mb-3">
                        Price: {{transanction_card.price}} ETH
                    </div>
                    <div class="font-weight ml-1 mb-3">
                        Owner: {{transanction_card.owner}}
                    </div>
                </v-card-text>
            </v-card-text>
            <v-card-actions>
                <v-col 
                    cols="5"></v-col>
                <v-col cols="8">
                <v-btn color="success" variant="tonal" :disabled="this.transanction_card.owner.toLowerCase() == this.account.toLowerCase()" @click="makeTransac()">CONFIRM</v-btn>
                <v-btn color="warning" variant="tonal" @click="dialog = false">CANCEL</v-btn></v-col>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>
  
<script>

    export default {
        name: 'marketHomePage',
        data: () => ({
        dialog: false,
        cards:[],
        types:[],
        rarity: [],
        transanction_card: {
            card_id: 0,
            level: 0,
            color: 0,
            price: 0,
            rarity: 1,
            owner: 0x0,
        },
        pic:[
            '/src/assets/red_1.jpg',
            '/src/assets/red_2.jpg',
            '/src/assets/red_3.jpg',
            '/src/assets/red_4.jpg',
            '/src/assets/green_1.jpg',
            '/src/assets/green_2.jpg',
            '/src/assets/green_3.jpg',
            '/src/assets/green_4.jpg',
            '/src/assets/blue_1.jpg',
            '/src/assets/blue_2.jpg',
            '/src/assets/blue_3.jpg',
            '/src/assets/blue_4.jpg',
            '/src/assets/yellow_1.jpg',
            '/src/assets/yellow_2.jpg',
            '/src/assets/yellow_3.jpg',
            '/src/assets/yellow_4.jpg',
        ],
        }),
        async mounted() {
            await this.checkWalletConnected();
            this.getMarketItems();
        },
        methods: {
            async jumpTo(dst) {
                this.$router.push(dst);
            },
            async checkWalletConnected() {
                try {
                    if (typeof window.ethereum !== "undefined") {
                        const accounts = await ethereum.request({ method: "eth_accounts" });
                        if (accounts.length !== 0) {
                            this.account = accounts[0];
                            this.addr = accounts[0];
                        }
                        else {
                            this.$router.push("/");
                        }
                    }
                    else {
                        this.$router.push("/");
                    }
                }
                catch (error) {
                    console.log(error);
                    this.$router.push("/");
                }
                var name = await this.contract.methods.get_username(this.account).call({ from: this.account });
                if (name == "" || name == null)
                    this.$router.push("/");
            },
            find_pic(color, level){
                if(color==1){
                    if(level<4)
                        return this.pic[0]
                    else if(level<7)
                        return this.pic[1]
                    else if(level<10)
                        return this.pic[2]
                    else 
                        return this.pic[3]
                }
                else if(color==2){
                    if(level<4)
                        return this.pic[4]
                    else if(level<7)
                        return this.pic[5]
                    else if(level<10)
                        return this.pic[6]
                    else 
                        return this.pic[7]
                }
                else if(color==3){
                    if(level<4)
                        return this.pic[8]
                    else if(level<7)
                        return this.pic[9]
                    else if(level<10)
                        return this.pic[10]
                    else 
                        return this.pic[11]
                }
                else{
                    if(level<4)
                        return this.pic[12]
                    else if(level<7)
                        return this.pic[13]
                    else if(level<10)
                        return this.pic[14]
                    else 
                        return this.pic[15]
                }
            },
            async makeAPurchaseforTest() {
                await this.contract.methods.purchase().call({from:this.account})
                await this.contract.methods.purchase().send({from:this.account})
            },
            async sellaCardForTest() {
                await this.contract.methods.sell(0, 2).send({from:this.account})
            },
            async getMySellingItems() {
                await this.contract.methods.show_my_selling().call({from:this.account})
            },
            async getAllSellingItems() {
                await this.contract.methods.all_selling().call({from:this.account})
            },
            async makeASearchForTest() {
                await this.contract.methods.rarity_search(1, 1).call({from:this.account})
            },
            getMarketItems() {
                this.contract.methods.all_selling().call({from:this.account})
	            .then((results) => {
                    this.cards = results[0];
                    this.types = results[1];
                });
            },
            buy(cardID, level, color, price, rarity, owned) {
                this.dialog = true;
                this.transanction_card.card_id = cardID;
                this.transanction_card.level = level;
                this.transanction_card.color = color;
                this.transanction_card.price = price;
                this.transanction_card.rarity = rarity;
                this.transanction_card.owner = owned;
            },
            async makeTransac() {
                this.dialog = false;
                await this.contract.methods.buy(this.transanction_card.card_id, this.transanction_card.price, this.transanction_card.owner).send({from:this.account, value:1e10})
                location.reload();
            }
        },
    }
</script>

<style scoped>
    .button {
        margin: 10px, 10px, 10px, 10px;
        text-align: right;
    }
    .fixed-bar {
    position: sticky;
    position: -webkit-sticky; /* for Safari */
    top: em;
    z-index: 2;
    }
</style>