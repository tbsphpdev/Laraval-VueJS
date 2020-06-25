<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Input; 

class GetTeamDataController extends Controller
{
    public function GetData($week){
        try{
            $weekdata = DB::select('call getpredeictions('.$week.')');
            $weewisekdata = DB::table('match_details')
                            ->select('match_details.*','t1.team_name as team1_name','t2.team_name as team2_name')
                            ->leftjoin('team_details as t1','t1._id','match_details.team_1')
                            ->leftjoin('team_details as t2','t2._id','match_details.team_2')
                            ->where('week',$week)
                            ->get();
            $data['week_data'] = [];
            $data['week_wise_data'] = $weewisekdata;
            foreach($weekdata as $week){
                $data['week_data'] [] = [
                    'team_id' => $week->team_id,
                    'team_name' =>$week->team_name,
                    'total_played' => $week->total_played,
                    'total_won' => $week->total_won,
                    'total_drawn' => $week->total_drawn,
                    'total_lost'=> $week->total_lost,
                    'total_gd' =>$week->total_gd,
                    'total_points' => $week->total_points,
                    'average_result' => number_format($week->average_result, 2, '.', '')
                ];
            }
            if($data){
                return response()->json(['status' => true, 'msg' => 'Week data get successfully', 'data' => $data]);
            }else{
                return response()->json(['status' => false, 'msg' => 'Data not found']);
            }
        }catch(\Exception $ex){
            DB::rollback();
            return response()->json(['status' => false, 'msg' => $ex->getMessage()]);
        }
    }

    public function UpdateData(Request $r){
        try{
            DB::beginTransaction();
            $match = DB::table('match_details')->where('_id', $r->match_id)->first();
            $team1_score = ($r->team == 'team1' ?  $r->new_value : $match->team1_score);  
            $team2_score = ($r->team == 'team2' ?  $r->new_value : $match->team2_score); 
            $update = DB::table('match_details')->where('_id', $r->match_id)->update(['team1_score' => $team1_score, 'team2_score' => $team2_score, 'updated_at' => date('Y-m-d h:i:s')]);
            if($update){ 
                if($team1_score > $team2_score){
                    DB::table('team_with_result')->where(['team_id' => $match->team_1, 'match_id' => $r->match_id])->update(['gd' => $team1_score, 'won' => 1, 'drawn' => 0, 'lost' =>0, 'points' => 3,'updated_at' => date('Y-m-d h:i:s')]);
                    DB::table('team_with_result')->where(['team_id' => $match->team_2, 'match_id' => $r->match_id])->update(['gd' => $team2_score, 'won' => 0, 'drawn' => 0, 'lost' =>1, 'points' => 0,'updated_at' => date('Y-m-d h:i:s')]);
                }else if($team1_score < $team2_score){
                    DB::table('team_with_result')->where(['team_id' => $match->team_1, 'match_id' => $r->match_id])->update(['gd' => $team1_score, 'won' => 0, 'drawn' => 0, 'lost' =>1, 'points' => 0,'updated_at' => date('Y-m-d h:i:s')]);
                    DB::table('team_with_result')->where(['team_id' => $match->team_2, 'match_id' => $r->match_id])->update(['gd' => $team2_score, 'won' => 1, 'drawn' => 0, 'lost' =>0, 'points' => 3,'updated_at' => date('Y-m-d h:i:s')]);
                }else{
                    DB::table('team_with_result')->where(['team_id' => $match->team_1, 'match_id' => $r->match_id])->update(['gd' => $team1_score, 'won' => 0, 'drawn' => 1, 'lost' =>0, 'points' => 1,'updated_at' => date('Y-m-d h:i:s')]);
                    DB::table('team_with_result')->where(['team_id' => $match->team_2, 'match_id' => $r->match_id])->update(['gd' => $team2_score, 'won' => 0, 'drawn' => 1, 'lost' =>0, 'points' => 1,'updated_at' => date('Y-m-d h:i:s')]);
                }
                DB::commit();
                return response()->json(['status' => true, 'msg' => 'Match Result updated successfully']);
            }else{
                return response()->json(['status' => true, 'msg' => 'Match Result not updated. Please try again']);
            }
        }catch(\Exception $ex){
            DB::rollback();
            return response()->json(['status' => false, 'msg' => $ex->getMessage()]);
        }
    }
}