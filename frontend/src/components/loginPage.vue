<template>
    <v-sheet class="pa-12 fill-height" >
        <v-img
            :aspect-ratio="8"
            src="/src/assets/MetaMask.png"
        ></v-img>
        <v-card class="mx-auto px-6 py-8" max-width="380">
            <v-btn
                :loading="loading"
                block
                color="success"
                size="large"
                type="submit"
                variant="elevated"
                @click="onSubmit()"
            >
                Sign In With MetaMask
            </v-btn>
            <!-- </v-form> -->
        </v-card>
        <v-dialog
            v-model="dialog"
            max-width="450"
        >
            <v-card>
                <v-card-text>
                    未安装MetaMask。
                </v-card-text>
                <v-card-actions>
                    <v-btn color="primary" variant="tonal" block @click="dialog = false">关闭</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog
            v-model="setUserName"
            max-width="600"
            persistent
        >
            <v-card>
                <v-card-text>
                    <v-container>
                        <v-text-field
                            label="Username"
                            v-model="this.username"
                            required
                        ></v-text-field>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                        :disabled="this.username == ''"
                        color="primary"
                        variant="tonal"
                        @click="signUp()"
                    >
                        SIGN UP
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-sheet>
</template>
  
<script>
    export default {
        name: 'loginPage',
        data: () => ({
            form: false,
            loading: false,
            dialog: false,
            setUserName: false,
            username: ""
        }),
        mounted() {
            this.checkWalletConnected()
        },
        methods: {
            async signUp() {
                this.contract.methods.set_username(this.username).call({from:this.account})
                    .then(function(results) {
                    });
                this.contract.methods.set_username(this.username).send({from:this.account})
                    .then(function(results) {
                    });
                var addr = this.account
                this.$router.push('/user')
            },
            async checkWalletConnected() {
                try {
                    this.loading = true
                    if (typeof window.ethereum !== 'undefined') {
                        const accounts = await ethereum.request({ method: 'eth_accounts' });
                        if (accounts.length !== 0) {
                            this.account = accounts[0];
                            var tmp_username;
                            tmp_username = await this.contract.methods.get_username(this.account).call({from:this.account})
                            if (tmp_username == "" || tmp_username == null) {
                                this.setUserName = true;
                            }
                            else {
                                this.$router.push('/user')
                            }
                        } else {
                            this.loading = false;
                        }
                    } else {
                        this.dialog = true;
                        this.loading = false;
                    }
                } catch (error) {
                    console.log(error);
                    this.loading = false;
                }
            },
            async onSubmit () {
                try {
                    this.loading = true
                    if (typeof window.ethereum !== 'undefined') {
                        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
                        this.account = accounts[0];
                        var tmp_username;
                        tmp_username = await this.contract.methods.get_username(this.account).call({from:this.account})
                        if (tmp_username == "" || tmp_username == null) {
                            this.setUserName = true;
                        }
                        else {
                            this.$router.push('/user')
                        }
                    } else {
                        this.dialog = true;
                        this.loading = false;
                    }
                } catch (error) {
                    console.log(error);
                    this.loading = false;
                }
            },
        },
    }
</script>