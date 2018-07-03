class Lsf
  attr_accessor :project, :defaults
  def initialize(project=ENV['LSF_PROJECT'],defaults={	J: "myjob", 
							e: "lsf_errors.tmp", 
							o: "lsf_output.tmp",
							q: "normal"
							})
    
    throw "Must supply an LSF project code" unless project
    @project = project 
    @defaults = defaults
  end

  def submit_job(command,options = {})
    redirect = options.delete(:redirect) 
    defaults.each do |k,v|
      options[k] = v unless options[k] || options[k.to_s]
    end
    
    options = options.keep_if{|k,v| k.match(/\A[xrNBqmnRJbtioefcWFMDSCkswEL]{1}\z/)}

    cmd = "bsub -P #{@project}"
    options.each do |k, v|
      cmd = cmd + " -#{k} #{v}" 
    end
    if redirect
      cmd = cmd + " \"#{command} > #{redirect}\""
    else
      cmd = cmd + " #{command}"
    end
    puts cmd
    system(cmd)
  end

end
