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
    <v-container class="pa-10 d-flex justify-center">
        <v-row class="d-flex align-center justify-center">  
            <v-col cols="2">
                <v-icon icon="mdi-treasure-chest" size="200"></v-icon>
            </v-col>
            
            <v-col cols="3" class="px-10">
                <v-btn
                    stacked
                    variant="flat"
                    @click="openBox()"
                    prepend-icon="mdi-key"
                    size="x-large"
                    :disabled="this.purchaseChance <= 0"
                >
                    open {{ this.purchaseChance }} / 2
                </v-btn>
            </v-col>
        </v-row>
    </v-container>
    <v-container>
        <v-row class="d-flex align-center justify-center">
            <v-card  v-if="this.card != null" width="310">
                <v-toolbar>
                    <v-toolbar-title class="text-h6">
                        Level {{ this.card.level }}
                    </v-toolbar-title>
                    <v-btn icon="mdi-check-bold" color="success" @click="this.card=null"></v-btn>
                </v-toolbar>
                <div class="px-2 py-0">
                    <v-img
                        height="350"
                        :src="this.pic[this.card.color][this.card.level]"
                        cover
                        class="text-white"
                    />
                </div>
                <v-card-text class="py-4">
                    <div class="font-weight py-0">
                        Rarity: {{this.card.num }}
                    </div>
                </v-card-text>
            </v-card>
            <v-card  v-else width="310">
                <v-toolbar>
                    <v-toolbar-title class="text-h6">
                        Level ?
                    </v-toolbar-title>
                </v-toolbar>
                <div class="px-2 py-0">
                    <v-img
                        height="350"
                        :lazy-src="this.pic[Math.ceil(Math.random() * 100) % 4][Math.ceil(Math.random() * 100) % 10]"
                        cover
                        class="text-white"
                    >
                        <template v-slot:placeholder>
                            <div class="d-flex align-center justify-center fill-height">
                                <v-progress-circular
                                    indeterminate
                                    color="grey-lighten-4"
                                ></v-progress-circular>
                            </div>
                        </template>
                    </v-img>
                </div>
                <v-card-text class="py-4">
                    <div class="font-weight py-0">
                        Rarity: ?
                    </div>
                </v-card-text>
            </v-card>
        </v-row>
    </v-container>

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
        name: 'personalHomePage',
        data: () => ({
            name: "",
            purchaseChance: 0,
            dialog: false,
            warning: "",
            card: null,
            pic: [
                ["/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_4.jpg"],
                ["/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_4.jpg"],
                ["/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_4.jpg"],
                ["/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_4.jpg"],
            ],
        }),
        async mounted() {
            await this.checkWalletConnected();
            this.getInfo();
        },
        methods: {
            async openBox() {
                this.purchaseChance = await this.contract.methods.purchaseChance().call({ from: this.account });
                if (this.purchaseChance <= 0) {
                    this.warning = "今日机会已用完。";
                    this.dialog = true;
                    return;
                }
                await this.contract.methods.purchase().send({ from: this.account })
                var tmp = await this.contract.methods.lastPurchased().call({ from: this.account })
                this.card = {
                    card_id: Number(tmp[0]["card_id"]),
                    color: Number(tmp[1]["color"]),
                    level: Number(tmp[1]["level"]),
                    num: Number(tmp[1]["num"]),
                }
                this.purchaseChance--;
            },
            closeWarning() {
                this.dialog = false;
                location.reload();
            },
            async getInfo() {
                this.name = await this.contract.methods.get_username(this.account).call({ from: this.account });
                if (this.name == "" || this.name == null)
                    this.$router.push("/");
                this.purchaseChance = await this.contract.methods.purchaseChance().call({ from: this.account });
            },
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
            },
        },
    }
</script>

<style scoped>
.fixed-bar {
  position: sticky;
  position: -webkit-sticky; /* for Safari */
  top: em;
  z-index: 2;
}
</style>