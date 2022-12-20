<template>
    <div>
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
    <v-container class="px-0 py-12">
        <v-row justify="center">
            <v-list-item v-for="(item, i) in this.card" :key="i">
            <v-col class="pa-0">
                <v-card width="240">
                    <v-toolbar>
                        <v-toolbar-title>
                            <div class="font-size:10">
                                Level {{item.level}},
                                Rarity {{item.num}}
                            </div>
                        </v-toolbar-title>
                    </v-toolbar>
                    <v-progress-linear color="primary" :model-value="item.point * 100 / (item.level * (item.level + 1) * 8)" height="12">
                        <template v-slot:default="{}">
                            <div class="text-caption font-weight-light">{{item.point}} / {{ (item.level * (item.level + 1) * 8) }}</div>
                        </template>
                    </v-progress-linear>
                    <div class="px-2 py-2">
                        <v-img
                            height="200"
                            :src="this.pic[item.color][item.level]"
                            cover
                            class="text-white"
                        />
                    </div>
                    <v-card-actions>
                    <div class="mx-auto">
                    <v-btn
                        text
                        variant="text"
                        color="primary"
                        @click="dialog = true;select(i);settype(0)"
                        :disabled="item.selling"
                    >
                        随机换色
                    </v-btn>
                    <v-btn
                        text
                        text-align="center"
                        variant="text"
                        color="primary"
                        :disabled="item.selling"
                        @click="dialog = true;select(i);settype(1)"
                    >
                        升级！
                    </v-btn>
                    </div>
                    </v-card-actions>
                </v-card>
            </v-col>
            </v-list-item>
        </v-row>
    </v-container>

    <v-dialog
        v-model="dialog"
        max-width="450"
        height = "500"
    >
        <v-card width="400">
            <v-card-title>
                请选择消耗的卡牌
            </v-card-title>
            <v-card-text>
                <v-container class="px-0 py-2">
                    <v-list-item v-for="(item, i) in this.card" :key="i">
                        <v-row class="px-10 py-6" justify="center">
                            <v-col cols="12" class="pa-0">
                                <v-card width="240" class="pa-0">
                                    <v-toolbar>
                                        <v-toolbar-title class="text-h6">
                                            Level {{ item.level }}, Rarity {{ item.num }}
                                        </v-toolbar-title>
                                    </v-toolbar>
                                    <v-progress-linear color="primary" :model-value="item.point * 100 / (item.level * (item.level + 1) * 8)" height="12">
                                        <template v-slot:default="{}">
                                        <div class="text-caption font-weight-light">{{item.point}} / {{ (item.level * (item.level + 1) * 8) }}</div>
                                        </template>
                                    </v-progress-linear>
                                    <div class="px-2 py-2">
                                        <v-img
                                            height="265"
                                            :src="this.pic[item.color][item.level]"
                                            cover
                                            class="text-white"
                                        />
                                    </div>
                                    <!-- <v-card-actions width="240" class="pa-0 ma-0"> -->
                                        <v-btn
                                            variant="tonal"
                                            block
                                            @click="select_material(i);"
                                            color="success"
                                            width="240"
                                            :disabled="selected===item.card_id || item.selling"
                                            class="rounded-ts-0 rounded-te-0"
                                        >
                                            confirm
                                        </v-btn>
                                    <!-- </v-card-actions> -->
                                </v-card>
                            </v-col>
                        </v-row>
                    </v-list-item>
                </v-container>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <!-- <v-btn color="success" variant="tonal"  @click="dialog = false;change_or_upgrade()">confirm</v-btn> -->
                <v-btn color="warning" variant="tonal"  @click="dialog = false;">cancel</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog> 
    </div>
</template>
  
<script>
    export default {
    name: "Upgrade",
    data: () => ({
        name: "-",
        addr: "-",
        dialog_type: 0,
        card: [],
        colorName: ["yellow", "red", "green", "blue"],
        pic: [
            ["/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_1.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_2.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_3.jpg", "/src/assets/yellow_4.jpg"],
            ["/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_1.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_2.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_3.jpg", "/src/assets/red_4.jpg"],
            ["/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_1.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_2.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_3.jpg", "/src/assets/green_4.jpg"],
            ["/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_1.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_2.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_3.jpg", "/src/assets/blue_4.jpg"],
        ],
        selected: 0,
        material: [],
        dialog: false,
        
    }),
    async mounted() {
        await this.checkWalletConnected();
        this.getInfo();
    },
    methods: {
        settype(i){
            this.dialog_type=i;
        },
        jumpTo(dst) {
            this.$router.push(dst);
        },
        async getInfo() {
            this.name = await this.contract.methods.get_username(this.account).call({ from: this.account });
            if (this.name == "" || this.name == null)
                this.$router.push("/");
            // await this.contract.methods.test().send({from: this.account});
            var tmp = await this.contract.methods.show_owned().call({ from: this.account });
            var cnt = -1;
            this.card=[];
            for (var i = 0; i < tmp[0].length; i++) {
                var item0 = tmp[0][i];
                var item1 = tmp[1][i];
                this.card.push({
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
        select(i){
            this.selected = this.card[i].card_id;
        },
        select_material(j){
            this.material.push(this.card[j].card_id);
            this.card.splice(j,1);
            this.dialog = false;
            this.change_or_upgrade();
        },
        
        async change_or_upgrade(){
            if(this.dialog_type==0){
                await this.change_color();
            }
            else{
                await this.upgrade();
            }
        },
        async change_color(){
            await this.contract.methods.change_color(this.selected, this.material).send({from:this.account})
            this.material = [];
            location.reload();
        },
        async upgrade(){
            await this.contract.methods.upgrade(this.selected, this.material).send({from:this.account})
            this.material = [];
            location.reload();
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