<template>
    <div class="px-2 mt-5">
        <div class="flex -mx-2">
            <div class="w-1/2 p-2 bg-white">
                <div>
                    <h2 class="text-center p-2">League Table</h2>
                    <div class="row-span-3">
                        <t-table
                        :headers="['Teams', 'PTS', 'P', 'W','D','L','GD']"
                        :data="teamdata.week_data" >
                        <template v-slot:row="props">
                            <tr>
                                <td>{{props.row.team_name}}</td>
                                <td>{{props.row.total_points}}</td>
                                <td>{{props.row.total_played}}</td>
                                <td>{{props.row.total_won}}</td>
                                <td>{{props.row.total_drawn}}</td>
                                <td>{{props.row.total_lost}}</td>
                                <td>{{props.row.total_gd}}</td>
                            </tr>
                            </template>
                        </t-table>
                    </div>
                </div>
                <div>
                    <p class="text-center p-2">{{week}} Week Match Result</p>
                    <div class="row-span-3">
                        <t-table
                        :data="teamdata.week_wise_data" >
                        <template v-slot:row="props">
                            <tr>
                                <td>{{props.row.team1_name}}</td>
                                <td>
                                <select v-model="props.row.team1_score" class="inline-grid" @change="update($event, props.row._id, 'team1')">
                                    <option value="0">0</option>
                                    <option v-for="index in 10" :value="index">{{index}}</option>
                                </select>
                                    -   
                                <select v-model="props.row.team2_score" class="inline-grid" @change="update($event, props.row._id, 'team2')">
                                    <option value="0">0</option>
                                    <option v-for="index in 10" :value="index">{{index}}</option>
                                </select>
                                
                                
                                </td>
                                <td>{{props.row.team2_name}}</td>
                            </tr>
                            </template>
                        </t-table>
                    </div>
                </div> 
                <template v-if="showButton == 1">
                <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" @click="showall">Play All</button>
                <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" @click="shownext">Next week</button>
                </template>
                <template v-else>
                    <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" @click="refresh">Refresh</button>
                </template>
            </div>
            <div class="w-1/2 p-2 bg-white">
                 <div class="">
                    <p class="text-center p-2">{{week}} Week Predictions Of Championship</p>
                    <div class="row-span-3">
                        <t-table
                        :data="teamdata.week_data" >
                        <template v-slot:row="props">
                            <tr>
                                <td>{{props.row.team_name}}</td>
                                <td>{{props.row.average_result}}</td>
                            </tr>
                            </template>
                        </t-table>
                    </div>
                </div> 
            </div>
        </div>
    </div>
</template>
<script>
    import TInput from 'vue-tailwind/src/elements/TInput.vue'
    export default {
        components:{
            TInput
        },
        data() {
            return {
                teamdata : [ ],
                showButton : 1
            }
        },
        created(){
            this.week = 1;
            this.fetachdata();
        },

        methods:{
            shownext(){
                if(this.week < 5){
                    this.week = this.week + 1;
                    fetch('api/get-week-data/'+ this.week)
                .then(res => res.json())
                    .then(res => {
                        this.teamdata = res.data;
                    }) 
                }
            },
           fetachdata(){
               fetch('api/get-week-data/'+ this.week)
               .then(res => res.json())
                .then(res => {
                    this.teamdata = res.data;
                })
           },
           showall(){
                this.showButton = 0;
                if(this.week < 5){
                    window.setInterval(() => {
                        this.shownext();
                    },2000);
                }
           },
           update(e, id, team){
                axios.post('api/update-data',{new_value: e.target.value, match_id: id, team: team })
                .then(response => { this.fetachdata()})
                .catch(error => {});
           },
           refresh(){
                window.location.reload();
           }
        }
    }
</script>