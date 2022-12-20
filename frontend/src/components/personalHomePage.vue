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
                    <div style="padding-top: 40px;">
                        <v-btn
                            variant="tonal"
                            prepend-icon="mdi-calendar-check"
                            :disabled="check"
                            @click="checkIn()"
                        >
                            check-in
                        </v-btn>
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
        <v-list-item v-for="(item, i) in this.card">
            <v-row class="px-10 py-6 d-flex align-center justify-center">
                <v-card v-if="item.length > 0" width="240" class="ma-16">
                    <v-toolbar>
                        <v-toolbar-title class="text-h6">
                            Level {{ item[0].level }}
                        </v-toolbar-title>
                        <v-btn icon="mdi-basket-plus" color="primary" :disabled="item[0].selling" @click="sell(item[0].card_id)"></v-btn>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="item[0].point * 100 / (item[0].level * (item[0].level + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{item[0].point}} / {{ (item[0].level * (item[0].level + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-0">
                        <v-img
                            height="265"
                            :src="this.pic[item[0].color][item[0].level]"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-text class="py-4">
                        <div class="font-weight py-0">
                            Rarity: {{ item[0].num }}
                        </div>
                    </v-card-text>
                </v-card>
                <v-card v-if="item.length > 1" width="240" class="ma-16">
                    <v-toolbar>
                        <v-toolbar-title class="text-h6">
                            Level {{ item[1].level }}
                        </v-toolbar-title>
                        <v-btn icon="mdi-basket-plus" color="primary" :disabled="item[1].selling" @click="sell(item[1].card_id)"></v-btn>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="item[1].point * 100 / (item[1].level * (item[1].level + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{item[1].point}} / {{ (item[1].level * (item[1].level + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-0">
                        <v-img
                            height="265"
                            :src="this.pic[item[1].color][item[1].level]"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-text class="py-4">
                        <div class="font-weight py-0">
                            Rarity: {{ item[1].num }}
                        </div>
                    </v-card-text>
                </v-card>
                <v-card v-if="item.length > 2" width="240" class="ma-16">
                    <v-toolbar>
                        <v-toolbar-title class="text-h6">
                            Level {{ item[2].level }}
                        </v-toolbar-title>
                        <v-btn icon="mdi-basket-plus" color="primary" :disabled="item[2].selling" @click="sell(item[2].card_id)"></v-btn>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="item[2].point * 100 / (item[2].level * (item[2].level + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{item[2].point}} / {{ (item[2].level * (item[2].level + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-0">
                        <v-img
                            height="265"
                            :src="this.pic[item[2].color][item[2].level]"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-text class="py-4">
                        <div class="font-weight py-0">
                            Rarity: {{ item[2].num }}
                        </div>
                    </v-card-text>
                </v-card>
                <v-card v-if="item.length > 3" width="240" class="ma-16">
                    <v-toolbar>
                        <v-toolbar-title class="text-h6">
                            Level {{ item[3].level }}
                        </v-toolbar-title>
                        <v-btn icon="mdi-basket-plus" color="primary" :disabled="item[3].selling" @click="sell(item[3].card_id)"></v-btn>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="item[3].point * 100 / (item[3].level * (item[3].level + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{item[3].point}} / {{ (item[3].level * (item[3].level + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-0">
                        <v-img
                            height="265"
                            :src="this.pic[item[3].color][item[3].level]"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-text class="py-4">
                        <div class="font-weight py-0">
                            Rarity: {{ item[3].num }}
                        </div>
                    </v-card-text>
                </v-card>
            </v-row>
        </v-list-item>
    </v-container>

    <v-dialog
        v-model="setPrice"
        max-width="600"
        persistent
    >
        <v-card>
            <v-card-text>
                <v-container>
                    <v-text-field
                        label="Price"
                        v-model="price"
                        suffix="ETH"
                        type="number"
                    ></v-text-field>
                </v-container>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                    :disabled="this.price == ''"
                    color="success"
                    variant="tonal"
                    @click="setSale()"
                >
                    confirm
                </v-btn>
                <v-btn
                    :disabled="this.price == ''"
                    color="warning"
                    variant="tonal"
                    @click="cancleSell()"
                >
                    cancel
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>

    <v-dialog
        v-model="dialog"
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
</template>
  
<script>
    export default {
    name: "personalHomePage",
    data: () => ({
        name: "-",
        addr: "-",
        card: [],
        colorName: ["yellow", "red", "green", "blue"],
        pic: [
            ["/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_4.jpg"],
            ["/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_4.jpg"],
            ["/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_4.jpg"],
            ["/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_4.jpg"],
        ],
        setPrice: false,
        price:1,
        tmpCardID: null,
        check: true,
        dialog: false,
        warning: "",
        toggle_none: 0
    }),
    async mounted() {
        await this.checkWalletConnected();
        this.getInfo();
    },
    methods: {
        async checkIn() {
            var tmp = await this.contract.methods.check().call({ from: this.account });
            if (!tmp) {
                this.warning = "今日已签到。"
                this.dialog = true;
            }
            this.check = true;
            location.reload();
            await this.contract.methods.check().send({ from: this.account });
        },
        closeWarning() {
            this.dialog = false;
            location.reload();
        },
        async setSale() {
            if (this.price <= 0) {
                this.warning = "价格需为正数。"
                this.dialog = true;
                return;
            }
            var tmp = await this.contract.methods.sell(this.tmpCardID, this.price).call({ from: this.account });
            if (!tmp) {
                this.setPrice = false;
                this.warning = "选中卡牌已在出售。"
                this.dialog = true;
                return;
            }
            
            await this.contract.methods.sell(this.tmpCardID, this.price).send({ from: this.account });
            this.price = 1;
            this.setPrice = false;
            location.reload();
        },
        cancleSell() {
            this.setPrice = false;
            this.tmpCardID = null;
        },
        sell(cardID) {
            this.setPrice = true;
            this.tmpCardID = cardID;
        },
        jumpTo(dst) {
            this.$router.push(dst);
        },
        async getInfo() {
            this.name = await this.contract.methods.get_username(this.account).call({ from: this.account });
            if (this.name == "" || this.name == null)
                this.$router.push("/");
            var tmp = await this.contract.methods.show_owned().call({ from: this.account });
            var cnt = -1;
            for (var i = 0; i < tmp[0].length; i++) {
                var item0 = tmp[0][i];
                var item1 = tmp[1][i];
                if (i % 4 == 0) {
                    var x = [];
                    this.card.push(x);
                    cnt++;
                }
                this.card[cnt].push({
                    card_id: Number(item0["card_id"]),
                    point: Number(item0["point"]),
                    selling: item0["selling"],
                    sell_money: Number(item0["sell_money"]),
                    owned: item0["owned"],
                    color: Number(item1["color"]),
                    level: Number(item1["level"]),
                    num: Number(item1["num"])
                });
            }
            tmp = await this.contract.methods.check().call({ from: this.account });
            this.check = !tmp;
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
        },
    },
}
</script>

<style scoped>
.fixed-bar {
  position: sticky;
  position: -webkit-sticky; /* for Safari */
  top: 0em;
  z-index: 2;
}
</style>