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
    <v-sheet class="px-6" >
        <br/>
        <v-row class="ma-n3 px-10">
            <v-col cols="3" class="px-16 py-12">
                <div class="px-16">
                    <v-avatar size="200">
                        <v-img
                            src="/src/assets/logo.png"
                            alt="John"
                        ></v-img>
                    </v-avatar>
                </div>
            </v-col>
            <v-col cols="9" class="py-12">
                <br/>
                <v-row class="py-4">
                    <div class="text-h2 px-10 py-5">
                        {{ this.name }}
                    </div>
                </v-row>
                <v-divider></v-divider>
                <div class="text-subtitle-1 px-10 py-4">
                    address: &nbsp; {{ this.addr }}
                </div>
            </v-col>
        </v-row>
        <v-row>
            <v-col cols="10"></v-col>
            <v-col>
            <div class="text-center">
                <v-btn-toggle v-model="toggle_none">
                    <v-btn class="ma-2" @click="jumpTo('/user')">All</v-btn>
                    <v-btn class="ma-2" @click="jumpTo('/userOwned')">On Sale</v-btn>
                </v-btn-toggle>
            </div></v-col>
        </v-row>
    </v-sheet>
    <v-container class="px-0 py-0">
        <v-list-item
            v-for="(item, index) in cards"
            :key="item.card_id"
        >
            <v-row class="px-10 py-6 d-flex align-center justify-center">
                    <v-card width="240" class="ma-16">
                        <v-toolbar>
                            <v-toolbar-title class="text-h6">
                                Level {{ types[index].level }}
                            </v-toolbar-title>
                            <template v-slot:append>
                                <v-btn color="primary" icon="mdi-dots-vertical" @click="buy(item.card_id, types[index].level, types[index].color, item.sell_money, types[index].num, item.owned)"></v-btn>
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
            </v-row>   
        </v-list-item>
    </v-container>
    <v-dialog
        v-model="dialog"
        max-width="400"
        height = "650"
        v-if="this.dialog" 
    >
        <v-card width="400" height="650" align-center>
            <v-card-title>
                CHANGE THE SELLING PRICE
            </v-card-title>
            <v-card-text>
                <div style="display: flex">
                    <v-img
                        height="322"
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
                </v-card-text>
            </v-card-text>
            <v-card-actions>
                <v-col 
                    cols="6">
                    <v-text-field label="Price" v-model="newPrice" type="number"></v-text-field>
                </v-col>
                <v-col cols="8">
                <v-btn color="success" variant="tonal" @click="makeTransac(newPrice)">CONFIRM</v-btn>
                <v-btn color="warning" variant="tonal" @click="dialog = false">CANCEL</v-btn></v-col>
            </v-card-actions>
        </v-card>
    </v-dialog>
    <v-dialog
        v-model="warn_dialog"
        max-width="450"
        persistent
    >
        <v-card>
            <v-card-text>
                {{ this.warning }}
            </v-card-text>
            <v-card-actions>
                <v-btn color="primary" variant="tonal" block @click="closeWarning()">关闭</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
    <v-dialog
        v-model="chooseFuncDialog"
        max-width="475"
        height = "150"
        v-if="this.chooseFuncDialog" 
    >
        <v-card width="475" height="200" align-center>
            <v-card-title>
                CHOOSE WHAT YOU WANNA DO
            </v-card-title>
            <v-divider></v-divider>
            <v-card-actions>
                <v-col cols="1"></v-col>
                <v-col>
                    <!-- <v-btn-toggle
                        v-model="text"
                        tile
                        group
                    > -->
                        <v-btn color="primary" variant="tonal" @click="changePrice()">
                            CHANGE PRICE
                        </v-btn>
                        <v-btn color="error" variant="tonal" @click="cancelSell()">
                            CANCEL SELLING
                        </v-btn>
                        <v-btn color="warning" variant="tonal" @click="chooseFuncDialog=false">
                            CANCEL
                        </v-btn>
                    <!-- </v-btn-toggle> -->
                </v-col>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>
  
<script>

    export default {
        name: 'userOwned',
        data: () => ({
        name: "-",
        addr: "-",
        chooseFuncDialog: false,
        dialog: false,
        newPrice: 0,
        cards:[],
        types:[],
        rarity: [],
        warn_dialog: false,
        warning: "",
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
        
            toggle_none: 1,
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
                    this.name = await this.contract.methods.get_username(this.account).call({ from: this.account });
                    if (this.name == "" || this.name == null)
                        this.$router.push("/");
                }
                catch (error) {
                    console.log(error);
                    this.$router.push("/");
                }
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
            getMarketItems() {
                this.contract.methods.show_my_selling().call({from:this.account})
	            .then((results) => {
                    this.cards = results[0];
                    this.types = results[1];
                });
            },
            closeWarning() {
                this.warn_dialog = false;
                location.reload();
            },
            buy(cardID, level, color, price, rarity, owned) {
                this.chooseFuncDialog = true;
                this.transanction_card.card_id = cardID;
                this.transanction_card.level = level;
                this.transanction_card.color = color;
                this.transanction_card.price = price;
                this.transanction_card.rarity = rarity;
                this.transanction_card.owner = owned;
            },
            async cancelSell() {
                this.chooseFuncDialog = false;
                await this.contract.methods.cancel_sell(this.transanction_card.card_id).call({from:this.account})
                await this.contract.methods.cancel_sell(this.transanction_card.card_id).send({from:this.account})
                location.reload();
            },
            changePrice() {
                this.chooseFuncDialog = false;
                this.dialog = true;
            },
            async makeTransac(price) {
                if (price <= 0) {
                    this.warning = "价格需为正数。"
                    this.warn_dialog = true;
                    return;
                }
                this.dialog = false;
                await this.contract.methods.change_money(this.transanction_card.card_id, price).call({from:this.account})
                await this.contract.methods.change_money(this.transanction_card.card_id, price).send({from:this.account})
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
</style>